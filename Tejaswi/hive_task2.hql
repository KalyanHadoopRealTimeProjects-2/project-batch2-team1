_task 2:
loading json file:
-------------------
hdfs dfs -mkdir -p /home/orienit/hive_json
download employee2_json file and paste into work folder
hdfs dfs -put /home/orienit/work/employee2_json /home/orienit/hive_json/employee2_json

create external table if not exist kalyan.employee2_json(empid int,name string,salary string,dept string)
row format serde 'org.apache.hive.hcatalog.data.JsonSerDe' stored as textfile
load data inpath '/home/orienit/hive_json/employee2_json' into table kalyan.employee2_json;

insert overwrite local directory '/home/orienit/store_result_json/json_result'
select * from kalyan.employee2_json where empid>2 and dept='dev';


loading xml file:
---------------------
hdfs dfs -mkdir -p /home/orienit/hive_xml
hdfs dfs -put /home/orienit/work/employee2_xml /home/orienit/hive_xml/employee2_xml

create external table if not exist kalyan.employee2_xml(empid int,name string,salary string,dept string)
ROW FORMAT SERDE 'com.ibm.spss.hive.serde2.xml.XmlSerDe'
WITH SERDEPROPERTIES (
"column.xpath.empid"="/employee/empid/text()",
"column.xpath.name"="/employee/name/text()",
"column.xpath.salary"="/employee/salary/text()",
"column.xpath.dept"="/employee/dept/text()",
)
STORED AS
INPUTFORMAT 'com.ibm.spss.hive.serde2.xml.XmlInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat'
TBLPROPERTIES (
"xmlinput.start"="<employee>",
"xmlinput.end"="</employee>"
);

load data inpath '/home/orienit/hive_xml/employee2_xml' into table table kalyan.employee2_xml;

insert local directory '/home/hadoop/store_result_xml/xml_result'
select * from kalyan.employee2_xml where empid>2 and dept='dev';


store the results:
------------------

create external table if not exist kalyan.employee2_op(empid int,name string ,salary srting,dept string);

load data local inpath '/home/orienit/store_result_json/json_result' into table kalyan.employee2_op;

insert into table kalyan.employee2_op(empid int,name string ,salary srting,dept string) local inpath '/home/orienit/store_result_xml' ;

select * from kalyan.employee2_op;

