------------------------------------ Task 1 ------------------------------------

select TEACHER [Код_преподавателя], TEACHER_NAME [Имя_преподавателя], GENDER [Пол], PULPIT [Кафедра] from TEACHER
where PULPIT = 'ИСиТ'
for xml path('Преподаватель'), root('Список_преподавателей'), elements

------------------------------------ Task 2 ------------------------------------

select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [Тип_Аудитории],
		  AUDITORIUM.AUDITORIUM_NAME [Номер_Аудитории],
		  AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость_Аудитории]
		  from AUDITORIUM
		  inner join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM_TYPE.AUDITORIUM_TYPE like '%ЛК%'
order by [Тип_Аудитории]
for xml auto, root('Список_Аудиторий'), elements

------------------------------------ Task 3 ------------------------------------

declare @xmlHandle int = 0,
      @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>
					<SUBJECTS> 
						<SUBJECT SUBJECT="ПН" SUBJECT_NAME="Пение" PULPIT="ИСиТ" /> 
						<SUBJECT SUBJECT="РСВН" SUBJECT_NAME="Рисование" PULPIT="ТЛ" /> 
						<SUBJECT SUBJECT="ТИХИЙ_ЧАС" SUBJECT_NAME="Тихий час" PULPIT="ТиП"  />  
					</SUBJECTS>'
exec sp_xml_preparedocument @xmlHandle output, @xml
select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20))       

begin tran
insert into SUBJECT select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20)) 
select * from SUBJECT where SUBJECT LIKE '%Н'
rollback tran
exec sp_xml_removedocument @xmlHandle

select * from SUBJECT

------------------------------------ Task 4 ------------------------------------

begin tran
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'Кашперко Елена Валерьевна', '1978-07-28',
'<Студент>
<Паспорт серия="CI" номер="1111111" дата="05.09.2017"/>
<Телефон>1234567</Телефон>
<Адрес>
       <Страна>Беларусь</Страна>
       <Город>Гомель</Город>
       <Улица>Денисенко</Улица>
       <Дом>330</Дом>
       <Квартира>18</Квартира>
</Адрес>
</Студент>')

update STUDENT set INFO= '
<Студент>
	<Паспорт серия="MP" номер="1234567" дата="13.03.2022"/>
	<Телефон>1234567</Телефон>
	<Адрес>
		   <Страна>Беларусь</Страна>
		   <Город>Минск</Город>
		   <Улица>Белорусская</Улица>
		   <Дом>21</Дом>
		   <Квартира>414</Квартира>
	</Адрес>
</Студент>' where INFO.value('(Студент/Адрес/Город)[1]','varchar(10)')='Гомель';

select IDGROUP,NAME,BDAY, 
INFO.value('(/Студент/Паспорт/@серия)[1]','varchar(10)') [Серия],
INFO.value('(/Студент/Паспорт/@номер)[1]', 'varchar(10)') [Номер паспорта],
INFO.query('/Студент/Адрес')[Адрес]
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
<xs:element name="Студент">
<xs:complexType><xs:sequence>
<xs:element name="Паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="Серия" type="xs:string" use="required" />
    <xs:attribute name="Номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="Дата"  use="required"  >
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="Телефон" type="xs:unsignedInt"/>
<xs:element name="Адрес">   <xs:complexType><xs:sequence>
   <xs:element name="Страна" type="xs:string" />
   <xs:element name="Город" type="xs:string" />
   <xs:element name="Улица" type="xs:string" />
   <xs:element name="Дом" type="xs:string" />
   <xs:element name="Квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>'

alter table STUDENT 
alter column INFO xml(Student)

begin tran
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'Кашперко Елена Валерьевна', '1978-07-28',
'<Студент>
<Паспорт Серия="CI" Номер="1111111" Дата="05.09.2017"/>
<Телефон>1234567</Телефон>
<Адрес>
       <Страна>Беларусь</Страна>
       <Город>Гомель</Город>
       <Улица>Денисенко</Улица>
       <Дом>330</Дом>
       <Квартира>18</Квартира>
</Адрес>
</Студент>')

update STUDENT set INFO= '
<Студент>
	<Паспорт Серия="MP" Номер="1234567" Дата="13.03.2022"/>
	<Телефон>1234567</Телефон>
	<Адрес>
		   <Страна>Беларусь</Страна>
		   <Город>Минск</Город>
		   <Улица>Белорусская</Улица>
		   <Дом>21</Дом>
		   <Квартира>414</Квартира>
	</Адрес>
</Студент>' where INFO.value('(Студент/Адрес/Город)[1]','varchar(10)')='Гомель';

select IDGROUP,NAME,BDAY, 
INFO.value('(/Студент/Адрес/Страна)[1]','varchar(10)') [страна],
INFO.query('/Студент/Адрес')[адрес]
from  STUDENT;
rollback

------------------------------------ Task 6 ------------------------------------

select rtrim(FACULTY.FACULTY) as '@код',
(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as 'количество_кафедр',
(select rtrim(PULPIT.PULPIT) as '@код',
(select rtrim(TEACHER.TEACHER) as 'преподаватель/@код', TEACHER.TEACHER_NAME as 'преподаватель'

from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('преподаватели'))
from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('кафедра'), type, root('кафедры'))
from FACULTY for xml path('факультет'), type, root('университет')


