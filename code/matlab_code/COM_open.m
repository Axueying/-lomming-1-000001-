function COM = COM_open(COM_num,BaudRate,deleteCOM)
%{
    ���ߣ�������
    COM_open����
    ���ܣ��򿪴���
    COM_num���ַ������ʹ��ں�
    BaudRate���������Ͳ�����
    deleteCOM��ɾ�����ڿ��أ�1Ϊɾ��
    COM���򿪴���ֵ
%}
if deleteCOM == 1
    delete(instrfindall);
end
s = serial(COM_num);
set(s,'BaudRate',BaudRate);
fopen(s);
COM = s;