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

// BSLLS:CommentedCode-off

///////////////////////////////////////////////////////////////////
// Расширяет возможности тестирования, позволяет легко менять логику работы системы:
// 
// * подменять результаты работы функций;
// * отключать алгоритмы и проверки;
// * выбрасывать исключения при необходимости;
// * собирать статистику по вызовам методов.
// 
// Для работы Мокито необходимо добавить обрабатываемые методы в расширение по следующей схеме:
// 
// ```bsl
// &Вместо("ВыполнитьЗапрос")
// Функция ЮТВыполнитьЗапрос(ПараметрыПодключения, Ресурс, HTTPМетод, Параметры, ОписаниеТела, Заголовки) Экспорт
// 	
// 	ПараметрыМетода = Мокито.МассивПараметров(ПараметрыПодключения, Ресурс, HTTPМетод, Параметры, ОписаниеТела, Заголовки);
// 	
// 	ПрерватьВыполнение = Ложь;
// 	Результат = МокитоПерехват.АнализВызова(РаботаСHTTP, "ВыполнитьЗапрос", ПараметрыМетода, ПрерватьВыполнение);
// 	
// 	Если НЕ ПрерватьВыполнение Тогда
// 		Возврат ПродолжитьВызов(ПараметрыПодключения, Ресурс, HTTPМетод, Параметры, ОписаниеТела, Заголовки);
// 	Иначе
// 		Возврат Результат;
// 	КонецЕсли;
// 	
// КонецФункции
// ```
///////////////////////////////////////////////////////////////////

// BSLLS:CommentedCode-on

#Область ПрограммныйИнтерфейс

// Начинает обучение (настройку) Мокито.
// После вызова этого метода следует набор правил для подмены логики работы системы.
// 
// Параметры:
//  Объект - Произвольный - Объект, методы которого хотим подменить.
//  СброситьСтарыеНастройки - Булево - Необходимо удалить старые настройки по объекту.
//        + `Истина` - все предыдущие настройки мокирования объекта будут забыты.
//        + `Ложь` - будет выполнено дообучение объекта.
//
// Возвращаемое значение:
//  ОбщийМодуль - см. МокитоОбучение
Функция Обучение(Объект, СброситьСтарыеНастройки = Истина) Экспорт
	
	Режимы = МокитоСлужебный.РежимыРаботы();
	МокитоСлужебный.УстановитьРежим(Режимы.Обучение);
	
	Возврат МокитоОбучение.Обучение(Объект, СброситьСтарыеНастройки);
	
КонецФункции

// Переводит мокито в режим прогона тестов.
// 
// Важно! Вызов этого метода обязателен перед выполнением тестового прогона метода.
// 
// Параметры:
//  СброситьСтатистику - Булево - Сбросить статистику прошлых прогонов
Процедура Прогон(СброситьСтатистику = Истина) Экспорт
	
	Режимы = МокитоСлужебный.РежимыРаботы();
	МокитоСлужебный.УстановитьРежим(Режимы.Тестирование);
	
	Если СброситьСтатистику Тогда
		МокитоСлужебный.ОчиститьСтатистику();
	КонецЕсли;
	
КонецПроцедуры

// Переводит мокито в режим проверки собранной за прогон статистики вызовов.
// 
// Параметры:
//  Объект - Произвольный - Устанавливает проверяемый объект, вызовы методов которого будем проверять.
//  Описание  - Строка - Описание проверки, которое будет выведено при возникновении ошибки
// Возвращаемое значение:
//  ОбщийМодуль - см. МокитоПроверки
Функция Проверить(Объект, Описание = Неопределено) Экспорт
	
	Режимы = МокитоСлужебный.РежимыРаботы();
	МокитоСлужебный.УстановитьРежим(Режимы.Проверка);
	
	Возврат МокитоПроверки.Проверить(Объект, Описание);
	
КонецФункции

// Сбрасывает настройки и повторно инициализирует мокито.
Процедура Сбросить() Экспорт
	
	МокитоСлужебный.СброситьПараметры();
	
КонецПроцедуры

#Область КонструкторыПараметров

// Возвращает маску параметра. Используется при обучении и проверках для фильтрации входных параметров метода.
// 
// Указывает, что в метод может передаваться любой параметр.
// Возвращаемое значение:
//  см. МокитоСлужебный.ОписаниеМаскиПараметра
Функция ЛюбойПараметр() Экспорт
	
	МаскаПараметра = МокитоСлужебный.ОписаниеМаскиПараметра(МокитоСлужебный.ТипыУсловийПараметров().Любой, 0);
	Возврат МаскаПараметра;
	
КонецФункции

// Возвращает маску параметра. Используется при обучении и проверках для фильтрации входных параметров метода.
// 
// Указывает, что в метод может передаваться числовой параметр.
// Возвращаемое значение:
//  см. Мокито.ТипизированныйПараметр
Функция ЧисловойПараметр() Экспорт
	
	Возврат ТипизированныйПараметр(Тип("Число"));
	
КонецФункции

// Возвращает маску параметра. Используется при обучении и проверках для фильтрации входных параметров метода.
// 
// Указывает, что в метод может передаваться строковый параметр
// Возвращаемое значение:
//  см. Мокито.ТипизированныйПараметр
Функция СтроковыйПараметр() Экспорт
	
	Возврат ТипизированныйПараметр(Тип("Строка"));
	
КонецФункции

// Возвращает маску параметра. Используется при обучении и проверках для фильтрации входных параметров метода.
// 
// Указывает, что в метод может передаваться параметр указанного типа.
// 
// Параметры:
//  Тип - Тип - Ограничение типа параметра.
// 
// Возвращаемое значение:
//  Структура - Описание маски параметра:
// * Режим - Строка - Тип маски  (значение: `Тип`)
// * Приоритет - Число - Приоритет маски, используется если значение подпадает под несколько масок  (значение: `10`)
// * Тип - Тип - Тип, которому должен соответствовать параметр
Функция ТипизированныйПараметр(Тип) Экспорт
	
	МаскаПараметра = МокитоСлужебный.ОписаниеМаскиПараметра(МокитоСлужебный.ТипыУсловийПараметров().Тип, 10);
	МаскаПараметра.Вставить("Тип", Тип);
	
	Возврат МаскаПараметра;
	
КонецФункции

// Формирует массив параметров. Применяется при обучении (настройке) мокито.
// Если параметр пропущен, то будет использовать маска см. ЛюбойПараметр
// 
// Параметры:
//  Параметр1 - Произвольный
//  Параметр2 - Произвольный
//  Параметр3 - Произвольный
//  Параметр4 - Произвольный
//  Параметр5 - Произвольный
//  Параметр6 - Произвольный
//  Параметр7 - Произвольный
//  Параметр8 - Произвольный
//  Параметр9 - Произвольный
//  Параметр10 - Произвольный
// 
// Возвращаемое значение:
//  Массив из Произвольный - Массив параметров
//@skip-check method-too-many-params
// BSLLS:NumberOfOptionalParams-off
// BSLLS:NumberOfParams-off
Функция МассивПараметров(Параметр1 = "_!%*",
						 Параметр2 = "_!%*",
						 Параметр3 = "_!%*",
						 Параметр4 = "_!%*",
						 Параметр5 = "_!%*",
						 Параметр6 = "_!%*",
						 Параметр7 = "_!%*",
						 Параметр8 = "_!%*",
						 Параметр9 = "_!%*",
						 Параметр10 = "_!%*") Экспорт
	
	Возврат ЮТОбщийСлужебный.ЗначениеВМассивеПоУмолчанию(Мокито.ЛюбойПараметр(),
														 Параметр1,
														 Параметр2,
														 Параметр3,
														 Параметр4,
														 Параметр5,
														 Параметр6,
														 Параметр7,
														 Параметр8,
														 Параметр9,
														 Параметр10);
	
КонецФункции

// BSLLS:NumberOfParams-on
// BSLLS:NumberOfOptionalParams-on

// Возвращает идентификатор значения входного параметра по умолчанию.
//
// Возвращаемое значение:
//  Строка
//
// Примеры:
//
// ЮТТесты.ДобавитьТест("Тест1")
// 	.СПараметрами(
// 		Мокито.ПараметрПоУмолчанию(),
// 		2); // Будет зарегистрирован один тест с параметрами <значение по умолчанию>, 2
//
Функция ПараметрПоУмолчанию() Экспорт
	
	Возврат "<[ЗначениеВходногоПараметраПоУмолчанию]>";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Анализ вызова.
// 
// Параметры:
//  Объект - Произвольный
//  ИмяМетода - Произвольный
//  ПараметрыМетода - Произвольный
//  ПрерватьВыполнение - Произвольный
// 
// Возвращаемое значение:
//  Произвольный - Подменный результат работы метода
Функция АнализВызова(Объект, ИмяМетода, ПараметрыМетода, ПрерватьВыполнение) Экспорт
	
	ЮТМетодыСлужебный.ВызовУстаревшегоМетода("Мокито.АнализВызова", "МокитоПерехват.АнализВызова", "24.03");
	
	Возврат МокитоСлужебный.АнализВызова(Объект, ИмяМетода, ПараметрыМетода, ПрерватьВыполнение);
	
КонецФункции

#КонецОбласти

#КонецОбласти
