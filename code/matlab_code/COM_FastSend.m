function sendback = COM_FastSend(COM,sendData)
%{
    作者：韩亚宁
    COM_FastSend函数
    功能：向串口发送内容
    COM：串口值
    sendData：向串口发送的内容
    sendback：是否发送成功，1为成功，0为失败
%}
try
    fprintf(COM,sendData);         % 给串口写入数据  
    sendback = 1;
catch
    sendback = 0;
end