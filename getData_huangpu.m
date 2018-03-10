function data_now=getData_huangpu()

data_now=zeros(1,6);
name_huangpu={'本部压力','公用压力','明日压力','大兴压力','金陵压力','红星压力'};

for i=1:6
     name= char(name_huangpu(i));
     
     conn = database('orcl','sjtuuser','sjtuuser_Gsdd2','oracle.jdbc.driver.OracleDriver','jdbc:oracle:thin:@10.10.10.134:1521/');

     
     sent=sprintf('select * from sjtu_warning_realtime where DATA_ITEM_NAME like ''%s'' ',name);
     curs=exec(conn,sent);
     curs=fetch(curs);
     data=curs.Data;
     
     press=cell2mat(data(1,3));
     data_now(1,i)=press;
     
end 
   
close(curs);
close(conn);
end




