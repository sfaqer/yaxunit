//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Функция ПоместитьФайлыВРабочийКаталог(Знач ПереданныеФайлы) Экспорт
	
	Контекст = Новый Структура();
	Контекст.Вставить("РабочийКаталог", ФайлыПроектаРабочийКаталог());
	
	ЮТФайлы.СоздатьКаталогРекурсивно(Контекст.РабочийКаталог);
	
	КаталогПроекта = ЮТНастройкиВыполнения.КаталогПроекта();
	
	ЕстьПолноеИмя = ЮТОбщий.ПеременнаяСодержитСвойство(ПереданныеФайлы[0], "ПолноеИмя");
	
	Для Каждого Файл Из ПереданныеФайлы Цикл
		
		ИмяФайла = ?(ЕстьПолноеИмя, Файл.ПолноеИмя, Файл.Имя);
		ИмяВКаталоге = СтрЗаменить(ИмяФайла, КаталогПроекта, "");
		ПолноеИмя = ЮТФайлы.ОбъединитьПути(Контекст.РабочийКаталог, ИмяВКаталоге);
		
		ЮТФайлы.СоздатьРодительскийКаталог(ПолноеИмя);
		ПолучитьИзВременногоХранилища(Файл.Хранение).Записать(ПолноеИмя);
		
	КонецЦикла;
	
	Возврат Контекст;
	
КонецФункции

Функция ФабрикаXDTO(Знач КаталогСхем) Экспорт
	
	Каталог = ЮТест.Зависимость(ЮТЗависимости.ФайлыПроекта(КаталогСхем)).ПолноеИмя;
	
	ПостроительСхем = Новый ПостроительСхемXML();
	ПостроительDOM = Новый ПостроительDOM();
	НаборСхем = Новый НаборСхемXML();
	
	ФайлыСхем = НайтиФайлы(Каталог, "*.xsd", Истина);
	
	Для Каждого Файл Из ФайлыСхем Цикл
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.ОткрытьФайл(Файл.ПолноеИмя);
		Схема = ПостроительСхем.СоздатьСхемуXML(ПостроительDOM.Прочитать(ЧтениеXML).ЭлементДокумента);
		ЧтениеXML.Закрыть();
		Если Схема <> Неопределено Тогда
			НаборСхем.Добавить(Схема);
		КонецЕсли;
		
	КонецЦикла;
	
	Фабрика = Новый ФабрикаXDTO(НаборСхем);
	
	Результат = ЮТФабрикаСлужебный.РезультатРазрешенияЗависимости();
	Результат.Успешно = Фабрика <> Неопределено;
	
	Если Результат.Успешно Тогда
		Результат.СохраняемыйКонтекст = Новый Структура("Фабрика", Фабрика);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФайлыПроектаРабочийКаталог()
	
	КлючБазы = ЮТОбщийСлужебный.ХешMD5(СтрокаСоединенияИнформационнойБазы());
	
	Возврат ЮТФайлы.ОбъединитьПути(КаталогВременныхФайлов(), КлючБазы, "КаталогПроекта");
	
КонецФункции

#КонецОбласти
