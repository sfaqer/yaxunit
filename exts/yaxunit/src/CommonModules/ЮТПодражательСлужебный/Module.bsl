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

Функция Локализация() Экспорт
	
	Контекст = Контекст();
	
	Возврат ?(ЗначениеЗаполнено(Контекст.Локализация), Контекст.Локализация, ЮТОкружение.ЛокальИнтерфейса());
	
КонецФункции

// Получает список из словаря с учетом установленной локализации
//
// Параметры:
//  ИмяРеализации - Строка - Имя реализации
//  ИмяСловаря - Строка - Имя словаря
//  КодЛокализации - Строка - Код локализации, по умолчанию берется из контекста
//
// Возвращаемое значение:
//	ФиксированныйМассив из Строка
Функция Словарь(ИмяРеализации, ИмяСловаря, Знач КодЛокализации = Неопределено) Экспорт
	
	КодЛокализации = ?(КодЛокализации = Неопределено, ЮТПодражатель.Локализация(), КодЛокализации);
	Возврат ЮТПодражательСлужебныйПовтИсп.Словарь(ИмяРеализации, ИмяСловаря, КодЛокализации);
	
КонецФункции

// Случайное значение из словаря.
//
// Параметры:
//  Словарь - Массив из Строка - Словарь
//
// Возвращаемое значение:
// 	- Строка
Функция СлучайноеЗначениеИзСловаря(Словарь) Экспорт
	
	Возврат Словарь.Получить(ЮТТестовыеДанные.СлучайноеЧисло(0, Словарь.ВГраница()));
	
КонецФункции

// Обработчик события "ИнициализацияКонтекста"
// 
// Параметры:
//  ДанныеКонтекста - Структура
Процедура ИнициализацияКонтекста(ДанныеКонтекста) Экспорт
	
	ДанныеКонтекста.Вставить(КлючКонтекста(), НовыйКонтекст());
	
КонецПроцедуры

// Контекст.
//
// Возвращаемое значение:
//  см. НовыйКонтекст
Функция Контекст() Экспорт
	
	//@skip-check constructor-function-return-section
	Возврат ЮТКонтекстСлужебный.ЗначениеКонтекста(КлючКонтекста());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючКонтекста()
	
	Возврат "Подражатель";
	
КонецФункции

// Новый контекст.
//
// Возвращаемое значение:
//  Структура - Новый контекст:
// * Локализация - см.  ЮТОкружение.ЛокальИнтерфейса
Функция НовыйКонтекст()
	
	Описание = Новый Структура;
	Описание.Вставить("Локализация", "");
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти
