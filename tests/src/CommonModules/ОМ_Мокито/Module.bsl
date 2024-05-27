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

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты.Тег("Мокирование")
		.ДобавитьТест("Обучение")
		.ДобавитьТест("Обучение_ЦепочкаВызовов")
		.ДобавитьТест("Проверить")
		.ДобавитьТест("Прогон_НакоплениеСтатистики").СПараметрами(Истина).СПараметрами(Ложь)
		.ДобавитьТест("ОшибкаПодбораРеакции")
		.ДобавитьТест("ИспользованиеПредикатов")
		.ДобавитьСерверныйТест("МокированиеМетодовСсылочныхОбъектов")
		.ДобавитьСерверныйТест("МокированиеЧерезМенеджер")
		.ДобавитьСерверныйТест("МокированиеЧерезСсылку")
		.ДобавитьСерверныйТест("МокированиеЧерезОбъект")
		.ДобавитьСерверныйТест("МокированиеМетодовРегистра")
		.ДобавитьСерверныйТест("МокированиеМетодовОбработки")
		.ДобавитьТест("МокированиеЦепочкиВызовов")
	;
	
КонецПроцедуры

Процедура Обучение() Экспорт
	
	Описание = "Обучение через явный вызов метода";
	
	ЛюбойПараметр = Мокито.ЛюбойПараметр();
	Адрес = "service.com";
	
	Мокито.Обучение(Интеграция)
		.Когда(Интеграция.ВыполнитьЗапрос(ЛюбойПараметр, ЛюбойПараметр, ЛюбойПараметр))
			.Вернуть(1)
		.Когда(Интеграция.ВыполнитьЗапрос(Адрес, ЛюбойПараметр, ЛюбойПараметр))
			.Вернуть(2)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Неопределено, 2), Описание + ". Кейс 1")
		.Равно(1);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, 1), Описание + ". Кейс 2")
		.Равно(2);
	
	Описание = "Обучение через указание имени и набора параметров";
	
	Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(Адрес, 1))
			.Вернуть(1)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(, 2))
			.Вернуть(2)
		.Когда("ВыполнитьЗапрос",)
			.Вернуть(20)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, 1), Описание + ". Кейс 1")
		.Равно(1);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, 2), Описание + ". Кейс 2")
		.Равно(2);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, 10), Описание + ". Кейс 3")
		.Равно(20);
	
КонецПроцедуры

Процедура Обучение_ЦепочкаВызовов() Экспорт
	
	Адрес = "service.com";
	Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос").Вернуть(0)
		.Когда(Интеграция.ВыполнитьЗапрос(Адрес)).Вернуть(1)
		.Когда(Интеграция.ВыполнитьЗапрос(Адрес)).Вернуть(2)
		.Когда(Интеграция.ВыполнитьЗапрос(Адрес)).Вернуть(3)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес), "Вызов 1").Равно(1);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес), "Вызов 2").Равно(2);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес), "Вызов 3").Равно(3);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес), "Вызов 4").Равно(3);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("Адрес"), "Вызов 5").Равно(0);
	
КонецПроцедуры

Процедура Проверить() Экспорт
	
	ЛюбойПараметр = Мокито.ЛюбойПараметр();
	Адрес = "service.com";
	
	Мокито.Обучение(Интеграция)
		.Когда(Интеграция.ВыполнитьЗапрос(ЛюбойПараметр, ЛюбойПараметр)).Вернуть(1)
		.Когда(Интеграция.ВыполнитьЗапрос(Адрес, 2)).Вернуть(10)
		.Прогон();
	
	Интеграция.ВыполнитьЗапрос("Адрес", Неопределено);
	Интеграция.ВыполнитьЗапрос(Адрес, 2);
	Интеграция.ВыполнитьЗапрос(1, 2);
	
	Мокито.Проверить(Интеграция)
		.КоличествоВызовов(Интеграция.ВыполнитьЗапрос(ЛюбойПараметр, Мокито.ЧисловойПараметр())).Больше(1).Равно(2)
		.КоличествоВызовов("ВыполнитьЗапрос").Заполнено().Равно(3).Меньше(6)
		.КоличествоВызовов("ПолучитьПочтовыеЯщикиIMAP").Пусто().Меньше(1)
		.КоличествоВызовов(Интеграция.ВыполнитьЗапрос(1, 2)).Равно(1)
		.КоличествоВызовов(Интеграция.ВыполнитьЗапрос(ЛюбойПараметр, ЛюбойПараметр)).Равно(3)
		.КоличествоВызовов(Интеграция.ВыполнитьЗапрос(Мокито.ТипизированныйПараметр(Тип("Строка")), ЛюбойПараметр)).Равно(2)
		;
	
	ВызовыМетода = Мокито.Проверить(Интеграция).Вызовы("ВыполнитьЗапрос");
	ЮТест.ОжидаетЧто(ВызовыМетода, "Вызовы метода ВыполнитьЗапрос")
		.ИмеетТип("Массив")
		.ИмеетДлину(3)
		.КаждыйЭлементСодержитСвойствоСоЗначением("Объект", Интеграция)
		.КаждыйЭлементСодержитСвойствоСоЗначением("ИмяМетода", "ВыполнитьЗапрос")
		.КаждыйЭлементСодержитСвойство("Параметры")
		.Свойство("[0].Параметры[0]").Равно("Адрес")
		.Свойство("[1].Параметры[0]").Равно(Адрес)
		.Свойство("[2].Параметры[1]").Равно(2);
	
КонецПроцедуры

#Если Сервер Тогда
Процедура МокированиеМетодовСсылочныхОбъектов() Экспорт
	
	Результат = Новый УникальныйИдентификатор();
	// Мокирование обработки проведения (выключение алгоритма проведения)
	Документ = ЮТест.Данные().СоздатьДокумент("Документы.ПриходТовара");
	Мокито.Обучение(Документ)
		.Когда("ОбработкаПроведения").Пропустить()
		.Прогон();
	
	Объект = Документ.ПолучитьОбъект();
	Объект.Записать(РежимЗаписиДокумента.Проведение);
	
	Мокито.Проверить(Объект).КоличествоВызовов("ОбработкаПроведения").Заполнено();
	Мокито.Проверить(Документ).КоличествоВызовов("ОбработкаПроведения").Заполнено();
	
	УстановитьПривилегированныйРежим(Истина);
	Справочник = ЮТест.Данные().СоздатьЭлемент(Справочники.Товары);
	СправочникОбъект = Справочник.ПолучитьОбъект();
	
	// Мокирование экспортного метода объекта, указание имени метода
	Описание = "Мокирование экспортного метода объекта, указание имени метода";
	Мокито.Обучение(Справочник)
		.Когда("ПечатнаяФормаШтрихкода").Вернуть(Результат)
		.Прогон();
	
	ЮТест.ОжидаетЧто(СправочникОбъект.ПечатнаяФормаШтрихкода(Неопределено), Описание)
		.Равно(Результат);
	
	Мокито.Проверить(Справочник).КоличествоВызовов("ПечатнаяФормаШтрихкода").Заполнено();
	
	// Мокирование экспортного метода объекта, явный вызов метода
	Мокито.Сбросить();
	Описание = "Мокирование экспортного метода объекта, явный вызов метода";
	Мокито.Обучение(СправочникОбъект)
		.Когда(СправочникОбъект.ПечатнаяФормаШтрихкода(Неопределено)).Вернуть(Результат)
		.Прогон();
	
	ЮТест.ОжидаетЧто(СправочникОбъект.ПечатнаяФормаШтрихкода(Неопределено), Описание)
		.Равно(Результат);
	
	Мокито.Проверить(Справочник).КоличествоВызовов("ПечатнаяФормаШтрихкода").Заполнено(Описание);
	
	// Мокирование приватного метода
	Пользователь = ЮТест.Данные().СоздатьЭлемент(Справочники.Пользователи);
	Мокито.Сбросить();
	Описание = "Мокирование приватного метода";
	Справочник = ЮТест.Данные().СоздатьЭлемент(Справочники.Встречи, , Новый Структура("Владелец", Пользователь));
	СправочникОбъект = Справочник.ПолучитьОбъект();
	СправочникОбъект.Начало = ТекущаяДатаСеанса();
	
	ЮТест.ОжидаетЧто(СправочникОбъект.ПроверитьЗаполнение())
		.ЭтоЛожь();
	
	Мокито.Обучение(СправочникОбъект)
		.Когда("УказанКорректныйПериод").Вернуть(Истина)
		.Прогон();
	
	ЮТест.ОжидаетЧто(СправочникОбъект.ПроверитьЗаполнение(), Описание + ". После мокирования")
		.ЭтоИстина();
	
	// Мокирование модуля менеджера
	Мокито.Сбросить();
	Элементы = Новый Массив(2);
	
	Описание = "Мокирование модуля менеджера";
	Мокито.Обучение(Справочники.Встречи)
		.Когда(Справочники.Встречи.СохранитьИзменения(Элементы)).Вернуть(Результат)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Справочники.Встречи.СохранитьИзменения(Элементы), Описание)
		.Равно(Результат);
	
КонецПроцедуры

Процедура МокированиеЧерезМенеджер() Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
	
	Владелец = Новый Структура("Имя", ЮТест.Данные().СлучайнаяСтрока());
	ЮТест.Данные().КонструкторОбъекта(Справочники.Пользователи)
		.Установить("Код", Владелец.Имя)
		.Записать();
	
	Запись = Новый Структура("Встреча, Начало, Конец, Владелец");
	Запись.Встреча = ЮТест.Данные().СоздатьЭлемент(Справочники.Встречи, , , ПараметрыЗаписи);
	Запись.Владелец = Владелец;
	
	Мокито.Обучение(Справочники.Встречи)
		.Наблюдать("СохранитьИзменения")
		.Наблюдать("ЗаполнитьОбъект")
		.Наблюдать("ПередЗаписью")
		.Прогон();
	
	ЮТест.ОжидаетЧто(МокитоСлужебный.Настройки()) // Проверка сформированных настроек
		.Свойство("Перехват").ИмеетСвойство(Справочники.Встречи)
		.Свойство("ТипыПерехватываемыхОбъектов").ИмеетДлину(2)
	;
	
	Успешно = Справочники.Встречи.СохранитьИзменения(ЮТКоллекции.ЗначениеВМассиве(Запись));
	
	ЮТест.ОжидаетЧто(Успешно).ЭтоИстина();
	
	Мокито.Проверить(Запись.Встреча, "Проверка через ссылку")
		.КоличествоВызовов("ПередЗаписью").Равно(1)
	;
	
	Мокито.Проверить(Справочники.Встречи, "Проверка через менеджер")
		.КоличествоВызовов("ЗаполнитьОбъект").Равно(1)
		.КоличествоВызовов("ПередЗаписью").Равно(1)
	;
КонецПроцедуры

Процедура МокированиеЧерезСсылку() Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
	Встреча = ЮТест.Данные().КонструкторОбъекта(Справочники.Встречи)
		.ФикцияОбязательныхПолей()
		.Записать();
	
	Мокито.Обучение(Встреча)
		.Когда("УказанКорректныйПериод").Вернуть(Истина)
		.Когда("УказанКорректныйПериод").Вернуть(Ложь)
		.Прогон();
	
	Объект = Встреча.ПолучитьОбъект();
	
	ЮТест.ОжидаетЧто(Объект.ПроверитьЗаполнение(), "Первая проверка")
		.ЭтоИстина()
		.Что(Объект.ПроверитьЗаполнение(), "Вторая проверка")
		.ЭтоЛожь()
		;
	
	Мокито.Проверить(Встреча)
		.КоличествоВызовов("УказанКорректныйПериод").Равно(2)
		;
	
КонецПроцедуры

Процедура МокированиеЧерезОбъект() Экспорт
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
	Встреча = ЮТест.Данные().КонструкторОбъекта(Справочники.Встречи)
		.ФикцияОбязательныхПолей()
		.Записать();
	
	Объект1 = Встреча.ПолучитьОбъект();
	Объект2 = Встреча.ПолучитьОбъект();
	
	Мокито.Обучение(Объект1)
			.Когда("УказанКорректныйПериод").Вернуть(Истина)
			.Когда("УказанКорректныйПериод").Вернуть(Ложь)
		.Обучение(Объект2)
			.Когда("УказанКорректныйПериод").Вернуть(Ложь)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Объект1.ПроверитьЗаполнение(), "Первая проверка")
		.ЭтоИстина()
		.Что(Объект1.ПроверитьЗаполнение(), "Вторая проверка")
		.ЭтоЛожь()
		.Что(Объект2.ПроверитьЗаполнение(), "Проверка второго объекта")
		.ЭтоЛожь()
	;
	
	Мокито.Проверить(Объект1)
		.КоличествоВызовов("УказанКорректныйПериод").Равно(2);
	Мокито.Проверить(Объект2)
		.КоличествоВызовов("УказанКорректныйПериод").Равно(1);
КонецПроцедуры

Процедура МокированиеМетодовРегистра() Экспорт
	
	Мокито.Обучение(РегистрыСведений.ЦеныТоваров)
		.Наблюдать("ОбработкаПроверкиЗаполнения")
		.Когда("ЗаполненоКорректно").Пропустить()
		.Когда("ЗаполненоКорректно").ВыброситьИсключение("Цена товара не может быть отрицательной")
		.Прогон()
		;
	
	НаборЗаписей = РегистрыСведений.ЦеныТоваров.СоздатьНаборЗаписей();
	ЮТест.ОжидаетЧто(НаборЗаписей)
		.Метод("ПроверитьЗаполнение")
		.НеВыбрасываетИсключение()
		.ВыбрасываетИсключение("Цена товара не может быть отрицательной");
	
	Мокито.Проверить(РегистрыСведений.ЦеныТоваров, "Через менеджер")
		.КоличествоВызовов("ЗаполненоКорректно").Равно(2)
		.КоличествоВызовов("ОбработкаПроверкиЗаполнения").Равно(2);
	
	Мокито.Проверить(НаборЗаписей, "Через набор")
		.КоличествоВызовов("ЗаполненоКорректно").Равно(0)
		.КоличествоВызовов("ОбработкаПроверкиЗаполнения").Равно(2);
	
	// Через набор записей
	Мокито.Сбросить();
	НаборЗаписей2 = РегистрыСведений.ЦеныТоваров.СоздатьНаборЗаписей();
	
	Мокито.Обучение(НаборЗаписей)
		.Наблюдать("ПередЗаписью")
		.Прогон();
	
	НаборЗаписей.Записать();
	НаборЗаписей2.Записать();
	
	Мокито.Проверить(НаборЗаписей, "Обучение через набор, проверка первого набора")
		.КоличествоВызовов("ПередЗаписью").Равно(1);
	Мокито.Проверить(НаборЗаписей2, "Обучение через набор, проверка второго набора")
		.КоличествоВызовов("ПередЗаписью").Равно(0);
	Мокито.Проверить(РегистрыСведений.ЦеныТоваров, "Обучение через набор, проверка через менеджер")
		.КоличествоВызовов("ПередЗаписью").Равно(1);
	
КонецПроцедуры

Процедура МокированиеМетодовОбработки() Экспорт
	
	Обработка = Обработки.ПроведениеДокументов.Создать();
	Обработка.ЗаполнитьСписок();
	ЮТест.ОжидаетЧто(Обработка.СписокДокументов)
		.Заполнено();
	
	Мокито.Обучение(Обработки.ПроведениеДокументов)
		.Когда("ЗаполнитьСписок").Пропустить()
		.Прогон();
	
	Обработка = Обработки.ПроведениеДокументов.Создать();
	
	Обработка.ЗаполнитьСписок();
	
	ЮТест.ОжидаетЧто(Обработка.СписокДокументов)
		.НеЗаполнено("Не сработал перехват события настроенного через менеджер");
	
	Мокито.Проверить(Обработка)
		.КоличествоВызовов("ЗаполнитьСписок").Равно(1);
	Мокито.Проверить(Обработки.ПроведениеДокументов)
		.КоличествоВызовов("ЗаполнитьСписок").Равно(1);
КонецПроцедуры

#КонецЕсли

Процедура Прогон_НакоплениеСтатистики(НакоплениеСтатистики) Экспорт
	
	Описание = ?(НакоплениеСтатистики, "Накопление статистики", "Сброс статистки");
	Адрес = "service.com";
	
	Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос").Вернуть(1)
		.Наблюдать("Методы")
		.Прогон();
	
	Интеграция.ВыполнитьЗапрос(Адрес);
	Интеграция.Методы();
	
	Мокито.Проверить(Интеграция)
		.КоличествоВызовов("ВыполнитьЗапрос").Равно(1)
		.КоличествоВызовов("Методы").Равно(1);
	
	Мокито.Прогон(НЕ НакоплениеСтатистики);
	
	Интеграция.ВыполнитьЗапрос(Адрес);
	Интеграция.Методы();
	
	Если НакоплениеСтатистики Тогда
		Мокито.Проверить(Интеграция)
			.КоличествоВызовов("ВыполнитьЗапрос").Равно(2)
			.КоличествоВызовов("Методы").Равно(2);
	Иначе
		Мокито.Проверить(Интеграция)
			.КоличествоВызовов("ВыполнитьЗапрос").Равно(1)
			.КоличествоВызовов("Методы").Равно(1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОшибкаПодбораРеакции() Экспорт
	
	Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос").ВыброситьИсключение("Не установлен ответ")
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров("api/versions"))
			.Вернуть(200)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров("sessions"))
			.Вернуть(200)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("api/versions")).Равно(200);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("sessions")).Равно(200);
	
	Мокито.Обучение(Интеграция, Ложь)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров("sessions"))
			.Вернуть(403)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("api/versions")).Равно(200);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("sessions")).Равно(403);
	
КонецПроцедуры

Процедура ИспользованиеПредикатов() Экспорт
	
	ЛюбойПараметр = Мокито.ЛюбойПараметр();
	УсловиеСтруктура = ЮТест.Предикат()
		.ИмеетТип("Структура")
		.Реквизит("Флаг").Равно(1)
		.Получить();
	Адрес = "service.ru";
	
	Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос")
		.ВыброситьИсключение("Не отработал перехват")
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЛюбойПараметр, УсловиеСтруктура))
		.	Вернуть(1)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЛюбойПараметр, ЮТест.Предикат().Реквизит("Флаг").Равно(2)))
			.Вернуть(2)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЛюбойПараметр, ЮТест.Предикат().ИмеетТип("Массив").Реквизит(0).Равно(3)))
			.Вернуть(3)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЛюбойПараметр, ЮТест.Предикат().Равно(4)))
			.Вернуть(4)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЮТест.Предикат().Содержит("com"), ЮТест.Предикат().Равно(4)))
			.Вернуть(5)
		.Когда("ВыполнитьЗапрос", Мокито.МассивПараметров(ЮТест.Предикат().Содержит("org").Получить(), ЮТест.Предикат().Равно(4)))
			.Вернуть(6)
		.Прогон()
	;
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, Новый Структура("Флаг", 1)))
		.Равно(1);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, 4))
		.Равно(4);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("service.com", 4))
		.Равно(4); // Не вернет 5, потому что если несколько предиктов в условиях параметров, нужно использовать Получить
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос("service.org", 4))
		.Равно(6); //
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, ЮТКоллекции.ЗначениеВМассиве(3)))
		.Равно(3);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(Адрес, Новый Структура("Флаг", 2)))
		.Равно(2);
	
	Мокито.Проверить(Интеграция)
		.КоличествоВызовов("ВыполнитьЗапрос").Равно(6)
		.КоличествоВызовов("ВыполнитьЗапрос", Мокито.МассивПараметров(ЮТест.Предикат().Содержит("ru"))).Равно(4)
		.КоличествоВызовов("ВыполнитьЗапрос", Мокито.МассивПараметров(ЛюбойПараметр, Новый Структура("Флаг", 2))).Равно(1)
	КонецПроцедуры
	
Процедура МокированиеЦепочкиВызовов() Экспорт
		
		Мокито.Обучение(Интеграция)
		.Когда("ВыполнитьЗапрос")
		.Вернуть(1)
		.Вернуть(2)
		.Вернуть(3)
		.Прогон();
	
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(""))
		.Равно(1);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(""))
		.Равно(2);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(""))
		.Равно(3);
	ЮТест.ОжидаетЧто(Интеграция.ВыполнитьЗапрос(""))
		.Равно(3);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
