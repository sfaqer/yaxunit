//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2022 BIA-Technologies Limited Liability Company
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

/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 
#Область ПрограммныйИнтерфейс

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции для служебного использования внутри подсистемы
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

// ЗагрузитьТесты
// 	Читает наборы тестов (тестовые модули) из расширений
// Параметры:
//  ПараметрыЗапускаТестов - см. ЮТФабрика.ПараметрыЗапуска
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеТестовогоМодуля - Набор описаний тестовых модулей, которые содержат информацию о запускаемых тестах
Функция ЗагрузитьТесты(ПараметрыЗапускаТестов) Экспорт
	
	Результат = Новый Массив;
	
	ЮТФильтрация.УстановитьКонтекст(ПараметрыЗапускаТестов);
	
	Для Каждого ОписаниеМодуля Из ТестовыеМодули() Цикл
		
		НаборыТестов = ТестовыеНаборыМодуля(ОписаниеМодуля, ПараметрыЗапускаТестов);
		
		Если НаборыТестов = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТестовыйМодуль = ЮТФабрика.ОписаниеТестовогоМодуля(ОписаниеМодуля, НаборыТестов);
		Результат.Добавить(ТестовыйМодуль);
		
	КонецЦикла;
		
	Возврат Результат;
	
КонецФункции

// ПрочитатьНаборТестов
// 	Читает набор тестов из модуля 
// Параметры:
//  МетаданныеМодуля - См. ЮТФабрика.ОписаниеМодуля
//  СтроковыйРежим - Строка - Строковый режим (контекст) исполнения теста
// 
// Возвращаемое значение:
//  Неопределено, Структура - Если прочитано, то будет возвращено описание набора. См. ОписаниеНабораТестов
Функция ИсполняемыеСценарииМодуля(ОписаниеМодуля) Экспорт
	
	ЭтоТестовыйМодуль = Истина;
	
	ЮТТесты.ПередЧтениемСценариевМодуля(ОписаниеМодуля);
	
	ПолноеИмяМетода = ОписаниеМодуля.Имя + ".ИсполняемыеСценарии";
	Ошибка = ЮТОбщий.ВыполнитьМетод(ПолноеИмяМетода, ЮТОбщий.ЗначениеВМассиве(Неопределено));
	
	Если Ошибка <> Неопределено Тогда
		
		ТипыОшибок = ЮТФабрика.ТипыОшибок();
		ТипОшибки = ЮТРегистрацияОшибок.ТипОшибки(Ошибка, ПолноеИмяМетода);
		
		Если ТипОшибки = ТипыОшибок.ТестНеРеализован Тогда
			ЭтоТестовыйМодуль = Ложь;
			Ошибка = Неопределено;
		ИначеЕсли ТипОшибки = ТипыОшибок.МногоПараметров Тогда
			Ошибка = ЮТОбщий.ВыполнитьМетод(ПолноеИмяМетода);
		КонецЕсли;
		
	КонецЕсли;
		
	Данные = ЮТТесты.СценарииМодуля();
	
	Если Ошибка <> Неопределено Тогда
		
		Данные = Новый Массив(); // Фиксируем, чтобы отобразить в отчете
		Описание = ЮТФабрика.ОписаниеТестовогоНабора(ОписаниеМодуля.Имя);
		ЮТРегистрацияОшибок.ЗарегистрироватьОшибкуЧтенияТестов(Описание, "Ошибка формирования списка тестовых методов", Ошибка);
		
		Данные.Добавить(Описание);
		
	ИначеЕсли ЭтоТестовыйМодуль Тогда
		
		Сценарии = ЮТТесты.СценарииМодуля();
		Данные = ЮТОбщий.ВыгрузитьЗначения(Сценарии.ТестовыеНаборы, "Значение");
		
		Данные = ЮТФильтрация.ОтфильтроватьТестовыеНаборы(Данные, ОписаниеМодуля);
		
	Иначе
		
		Данные = Неопределено;
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

// ЭтоТестовыйМодуль
//   Проверяет, является ли модуль модулем с тестами
// Параметры:
//  МетаданныеМодуля - Структура - Описание метаданных модуля, см. ЮТФабрика.ОписаниеМодуля
// 
// Возвращаемое значение:
//  Булево - Этот модуль содержит тесты
Функция ЭтоТестовыйМодуль(МетаданныеМодуля) Экспорт

#Если Сервер Тогда
	Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
#КонецЕсли
	
#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТонкийКлиент Тогда
	Если МетаданныеМодуля.КлиентУправляемоеПриложение Тогда
		Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если МетаданныеМодуля.КлиентОбычноеПриложение Тогда
		Возврат ЮТОбщий.МетодМодуляСуществует(МетаданныеМодуля.Имя, ИмяМетодаСценариев());
	КонецЕсли;
#КонецЕсли
	
	Если МетаданныеМодуля.Сервер Тогда
		Возврат ЮТЧитательСервер.ЭтоТестовыйМодуль(МетаданныеМодуля);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, составляющие внутреннюю реализацию модуля 
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныеПроцедурыИФункции

Функция ИмяМетодаСценариев()
	
	Возврат "ИсполняемыеСценарии";
	
КонецФункции

// ТестовыеМодули
//  Возвращает описания модулей, содержащих тесты
// Возвращаемое значение:
//  Массив из см. ЮТМетаданныеСервер.МетаданныеМодуля - Тестовые модули
Функция ТестовыеМодули()
	
	ТестовыеМодули = Новый Массив;
	
	МодулиРасширения = ЮТМетаданныеСервер.МодулиРасширений();
	
	Для Каждого ОписаниеМодуля Из МодулиРасширения Цикл
		
		Если ЮТФильтрация.ЭтоПодходящийМодуль(ОписаниеМодуля) И ЭтоТестовыйМодуль(ОписаниеМодуля) Тогда
			
			ТестовыеМодули.Добавить(ОписаниеМодуля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТестовыеМодули;
	
КонецФункции

Функция ТестовыеНаборыМодуля(Модуль, ПараметрыЗапуска)
	
	// TODO Фильтрация по путям
	НаборыТестов = Неопределено;
	
#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	Если Модуль.КлиентОбычноеПриложение ИЛИ Модуль.КлиентУправляемоеПриложение Тогда
		НаборыТестов = ИсполняемыеСценарииМодуля(Модуль);
	ИначеЕсли Модуль.Сервер Тогда
		НаборыТестов = ЮТЧитательСервер.ИсполняемыеСценарииМодуля(Модуль);
	КонецЕсли;
#ИначеЕсли Сервер Тогда
	Если Модуль.Сервер Тогда
		НаборыТестов = ИсполняемыеСценарииМодуля(Модуль);
	Иначе
		ВызватьИсключение "Чтение списка тестов модуля в недоступном контексте";
	КонецЕсли;
#ИначеЕсли Клиент Тогда
	Если Модуль.КлиентУправляемоеПриложение Тогда
		НаборыТестов = ИсполняемыеСценарииМодуля(Модуль);
	ИначеЕсли Модуль.Сервер Тогда
		НаборыТестов = ЮТЧитательСервер.ИсполняемыеСценарииМодуля(Модуль);
	КонецЕсли;
#КонецЕсли

	Возврат НаборыТестов;
	
КонецФункции

Функция Фильтр(ПараметрыЗапуска)
	
	Фильтр = Новый Структура("Расширения, Модули, Наборы, Теги, Контексты, Пути");
	
	Фильтр.Расширения = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "extensions");
	Фильтр.Модули = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "modules");
	Фильтр.Теги = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "tags");
	Фильтр.Контексты = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "contexts");
	// TODO: Подумать в каком формате задать наборы - ИмяМодуля.Набор, Набор или другой вариант
	Фильтр.Наборы = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "suites");
	
	// TODO: Обработка путей в формате: Модуль.ИмяТеста, ИмяТеста - метод, параметры, контекст
	// ОМ_ЮТУтверждения.Что[0: 1].Сервер, ОМ_ЮТУтверждения.Что[1: Структура].Сервер
	Фильтр.Пути = ЮТОбщий.ЗначениеСтруктуры(ПараметрыЗапуска.filter, "paths");
	
	Возврат Фильтр;
	
КонецФункции

#КонецОбласти
