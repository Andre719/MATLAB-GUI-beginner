function out=boarder_huangpu()

name_huangpu={'本部压力','公用压力','明日压力','大兴压力','金陵压力','红星压力'};

%连接数据库
conn = database('orcl','sjtuuser','sjtuuser_Gsdd2','oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:@10.10.10.134:1521/');
flag = isopen(conn);
fprintf('flag is %d.\n',flag);

%读取当前时间
t=clock;
year=t(1);
month=t(2);
day=t(3);
hour=t(4);
min=t(5);
all = 0;
   
threshold=zeros(480,2,6);   %阈值数组
       
for i=1:6
    name= char(name_huangpu(i));
    %press=cell2mat(data_now(i,3));
    %date=char(data_now(i,4));
   
    %year=str2num(date(1:4));
    %month=str2num(date(6:7));
    %day=str2num(date(9:10));
    %hour=str2num(date(12:13));
    %min=str2num(date(15:16));
    
    dayStr=[];    %过去7天
    for j=1:7
       day_temp = day-j;
       month_temp = month;
       year_temp = year;
       if day_temp == 0
           day_temp = day_temp+30;
           month_temp = month_temp-1;
           if month_temp == 0
               month_temp =month_temp+12;
               year_temp = year_temp-1;
           end
       end
       dayStr=[dayStr;year_temp,month_temp,day_temp];
    end

    %读历史数据
    conn = database('orcl','sjtuuser','sjtuuser_Gsdd2','oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:@10.10.10.134:1521/');
    sent=sprintf('select * from sjtu_warning_history where DATA_ITEM_NAME like ''%s'' ',name);
    curs=exec(conn,sent);
    curs=fetch(curs);
    data_history=curs.Data;
   
    [m,n]=size(data_history);
    pressure=zeros(480,30);
    count=zeros(1,480);
    for jj=m:-1:1
        date_all = char(data_history(jj,4));
        date_year = str2num(date_all(1:4));
        date_month = str2num(date_all(6:7));
        date_day = str2num(date_all(9:10));
        date_hour = str2num(date_all(12:13))+1;
        date_min = str2num(date_all(15:16));
      
        fflag=0;
        for t=1:7
          if ((date_year == dayStr(t,1)) && (date_month == dayStr(t,2)) && (date_day==dayStr(t,3)) ) 
              fflag=1;
              break;
          end   
        end
      
        %fprintf('%s - %d\n',date_hour,date_min);
              
        if ((fflag == 1) &&  (cell2mat(data_history(jj,7))==0) ) %&& (date_hour == hour)% && (abs(date_min-min) < 5))
           %fprintf('%d-%d-%d %d:%d\n',date_year,date_month,date_day,date_hour,date_min); 
           col_min=floor(date_min/3)+1;
           row_hour=(date_hour-1)*20+col_min;
           count(1,row_hour)=count(1,row_hour)+1;                  
           if(cell2mat(data_history(jj,8))==1)
              pressure(row_hour,count(1,row_hour))=cell2mat(data_history(jj,9)); 
           else
              pressure(row_hour,count(1,row_hour))=cell2mat(data_history(jj,3)); 
           end
        end
                     
    end
  
    %算阈值
    for h=1:480
       temp_press=[];
       for c=1:count(1,h)
          temp_press=[temp_press,pressure(h,c)];
       end
       aver=mean(temp_press);
       delta=std(temp_press);
       threshold(h,1,i)=aver-3*delta;
       threshold(h,2,i)=aver+3*delta;
    end        
end 

out=threshold;

close(curs);
close(conn);
end