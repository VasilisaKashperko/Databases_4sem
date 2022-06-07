------------------------------------ Task 1 ------------------------------------

select TEACHER [���_�������������], TEACHER_NAME [���_�������������], GENDER [���], PULPIT [�������] from TEACHER
where PULPIT = '����'
for xml path('�������������'), root('������_��������������'), elements

------------------------------------ Task 2 ------------------------------------

select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [���_���������],
		  AUDITORIUM.AUDITORIUM_NAME [�����_���������],
		  AUDITORIUM.AUDITORIUM_CAPACITY [�����������_���������]
		  from AUDITORIUM
		  inner join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM_TYPE.AUDITORIUM_TYPE like '%��%'
order by [���_���������]
for xml auto, root('������_���������'), elements

------------------------------------ Task 3 ------------------------------------

declare @xmlHandle int = 0,
      @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>
					<SUBJECTS> 
						<SUBJECT SUBJECT="��" SUBJECT_NAME="�����" PULPIT="����" /> 
						<SUBJECT SUBJECT="����" SUBJECT_NAME="���������" PULPIT="��" /> 
						<SUBJECT SUBJECT="�����_���" SUBJECT_NAME="����� ���" PULPIT="���"  />  
					</SUBJECTS>'
exec sp_xml_preparedocument @xmlHandle output, @xml
select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20))       

begin tran
insert into SUBJECT select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20)) 
select * from SUBJECT where SUBJECT LIKE '%�'
rollback tran
exec sp_xml_removedocument @xmlHandle

select * from SUBJECT

------------------------------------ Task 4 ------------------------------------

begin tran
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'�������� ����� ����������', '1978-07-28',
'<�������>
<������� �����="CI" �����="1111111" ����="05.09.2017"/>
<�������>1234567</�������>
<�����>
       <������>��������</������>
       <�����>������</�����>
       <�����>���������</�����>
       <���>330</���>
       <��������>18</��������>
</�����>
</�������>')

update STUDENT set INFO= '
<�������>
	<������� �����="MP" �����="1234567" ����="13.03.2022"/>
	<�������>1234567</�������>
	<�����>
		   <������>��������</������>
		   <�����>�����</�����>
		   <�����>�����������</�����>
		   <���>21</���>
		   <��������>414</��������>
	</�����>
</�������>' where INFO.value('(�������/�����/�����)[1]','varchar(10)')='������';

select IDGROUP,NAME,BDAY, 
INFO.value('(/�������/�������/@�����)[1]','varchar(10)') [�����],
INFO.value('(/�������/�������/@�����)[1]', 'varchar(10)') [����� ��������],
INFO.query('/�������/�����')[�����]
from  STUDENT;

rollback

------------------------------------ Task 5 ------------------------------------

drop xml schema collection Student;

begin tran
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required"  >
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>'

alter table STUDENT 
alter column INFO xml(Student)

begin tran
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'�������� ����� ����������', '1978-07-28',
'<�������>
<������� �����="CI" �����="1111111" ����="05.09.2017"/>
<�������>1234567</�������>
<�����>
       <������>��������</������>
       <�����>������</�����>
       <�����>���������</�����>
       <���>330</���>
       <��������>18</��������>
</�����>
</�������>')

update STUDENT set INFO= '
<�������>
	<������� �����="MP" �����="1234567" ����="13.03.2022"/>
	<�������>1234567</�������>
	<�����>
		   <������>��������</������>
		   <�����>�����</�����>
		   <�����>�����������</�����>
		   <���>21</���>
		   <��������>414</��������>
	</�����>
</�������>' where INFO.value('(�������/�����/�����)[1]','varchar(10)')='������';

select IDGROUP,NAME,BDAY, 
INFO.value('(/�������/�����/������)[1]','varchar(10)') [������],
INFO.query('/�������/�����')[�����]
from  STUDENT;
rollback

------------------------------------ Task 6 ------------------------------------

select rtrim(FACULTY.FACULTY) as '@���',
(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as '����������_������',
(select rtrim(PULPIT.PULPIT) as '@���',
(select rtrim(TEACHER.TEACHER) as '�������������/@���', TEACHER.TEACHER_NAME as '�������������'

from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('�������������'))
from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('�������'), type, root('�������'))
from FACULTY for xml path('���������'), type, root('�����������')


