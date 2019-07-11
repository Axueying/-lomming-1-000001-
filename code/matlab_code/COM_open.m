function COM = COM_open(COM_num,BaudRate,deleteCOM)
%{
    作者：韩亚宁
    COM_open函数
    功能：打开串口
    COM_num：字符串类型串口号
    BaudRate：数字类型波特率
    deleteCOM：删除串口开关，1为删除
    COM：打开串口值
%}
if deleteCOM == 1
    delete(instrfindall);
end
s = serial(COM_num);
set(s,'BaudRate',BaudRate);
fopen(s);
COM = s;