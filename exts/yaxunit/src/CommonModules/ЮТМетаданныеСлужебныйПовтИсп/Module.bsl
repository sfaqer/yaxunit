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

Функция МодулиПодсистемы(ИмяПодсистемы, Серверные, Клиентские) Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.МодулиПодсистемы(ИмяПодсистемы, Серверные, Клиентские);
	
КонецФункции

Функция ОписаниеОбъектаМетаданных(Знач Менеджер) Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.ОписаниеОбъектаМетаданных(Менеджер);
	
КонецФункции

Функция ОписаниеОбъектаМетаданныхПоИдентификаторуТипа(Знач ИдентификаторТипа) Экспорт
	
	Тип = ЮТТипыДанныхСлужебный.ТипПоИдентификатору(ИдентификаторТипа);
	Возврат ЮТМетаданныеСлужебныйВызовСервера.ОписаниеОбъектаМетаданных(Тип);
	
КонецФункции

Функция ТипыМетаданных() Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.ТипыМетаданных();
	
КонецФункции

Функция РазрешеныСинхронныеВызовы() Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.РазрешеныСинхронныеВызовы();
	
КонецФункции

Функция РегистрыДвиженийДокумента(ПолноеИмя) Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.РегистрыДвиженийДокумента(ПолноеИмя);
	
КонецФункции

Функция ВариантВстроенногоЯзыка() Экспорт

	Возврат ЮТМетаданныеСлужебныйВызовСервера.ВариантВстроенногоЯзыка();

КонецФункции

Функция ВерсияДвижка() Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.ВерсияДвижка();
	
КонецФункции

Функция ПодсистемыПодключаемыхМодулей() Экспорт
	
	Возврат ЮТМетаданныеСлужебныйВызовСервера.ПодсистемыПодключаемыхМодулей();
	
КонецФункции

#КонецОбласти
