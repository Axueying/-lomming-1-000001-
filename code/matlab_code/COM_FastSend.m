function sendback = COM_FastSend(COM,sendData)
%{
    ���ߣ�������
    COM_FastSend����
    ���ܣ��򴮿ڷ�������
    COM������ֵ
    sendData���򴮿ڷ��͵�����
    sendback���Ƿ��ͳɹ���1Ϊ�ɹ���0Ϊʧ��
%}
try
    fprintf(COM,sendData);         % ������д������  
    sendback = 1;
catch
    sendback = 0;
end