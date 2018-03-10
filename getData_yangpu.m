function data_now=getData_yangpu()

data_now=zeros(1,8);
name_yangpu={'大连压力','19棉压力','国翔压力','翔中压力','中原压力','武东压力','杨居管压力','开鲁压力'};

for i=1:8
     name= char(name_yangpu(i));
     
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




