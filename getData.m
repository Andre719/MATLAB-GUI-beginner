function data_now=getData()

data_now=zeros(1,5);
name_hongkou={'����ѹ��','����ѹ��','����ѹ��','����ѹ��','����ѹ��'};

for i=1:5
     name= char(name_hongkou(i));
     
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




