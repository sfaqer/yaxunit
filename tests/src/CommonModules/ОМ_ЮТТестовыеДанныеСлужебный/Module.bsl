//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
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
	
	КодТовара = ЮТОбщий.ЧислоВСтроку(ЮТест.Данные().СлучайноеПоложительноеЧисло(999999999));
	Период = ТекущаяДата();
	
	ЮТТесты
		.ВТранзакции()
		.УдалениеТестовыхДанных()
		.ДобавитьТест("Фикция")
			.СПараметрами(Новый ОписаниеТипов("Число"))
			.СПараметрами(Новый ОписаниеТипов("Строка"))
			.СПараметрами(Новый ОписаниеТипов("Дата"))
			.СПараметрами(Новый ОписаниеТипов("Булево"))
			.СПараметрами(Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(3, 2, ДопустимыйЗнак.Неотрицательный)))
			.СПараметрами(Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(3)))
			.СПараметрами(Новый ОписаниеТипов("Дата", , , , , Новый КвалификаторыДаты(ЧастиДаты.Время)))
			.СПараметрами(Новый ОписаниеТипов("СправочникСсылка.Банки"))
			.СПараметрами(Новый ОписаниеТипов("ДокументСсылка.Заказ"))
			.СПараметрами(Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияЗаказов"))
			.СПараметрами(Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыХарактеристик"))
			.СПараметрами(Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыХарактеристик, СправочникСсылка.Банки, ПеречислениеСсылка.СостоянияЗаказов"))
			.СПараметрами(Новый ОписаниеТипов("ВидДвиженияНакопления"))
		.ДобавитьТест("УдалениеТестовыхДанныхСправочник")
			.СПараметрами(КодТовара)
			.СПараметрами(КодТовара)
		.ДобавитьТест("УдалениеТестовыхДанныхДокумент")
			.СПараметрами(КодТовара)
			.СПараметрами(КодТовара)
		.ДобавитьТест("УдалениеТестовыхДанныхРегистрСведений")
			.СПараметрами(Период)
			.СПараметрами(Период)
		.ДобавитьТест("НеУдалениеТестовыхДанныхВызовСервера")
	;
	
КонецПроцедуры

Процедура Фикция(ОписаниеТипа) Экспорт
	
	Результат = ЮТТестовыеДанныеСлужебный.Фикция(ОписаниеТипа);
	
	ЮТест.ОжидаетЧто(Результат)
		.Заполнено()
		.ИмеетТип(ОписаниеТипа);
	
КонецПроцедуры

Процедура УдалениеТестовыхДанныхСправочник(Код) Экспорт
	
	СоздатьСсылку("Тест", Код);
	
	Ссылки = ЮТест.Контекст().Значение("Ссылки");
	СсылкаСуществует(Ссылки.Набор, "Набор");
	
КонецПроцедуры

Процедура НеУдалениеТестовыхДанныхВызовСервера() Экспорт
	
	Ссылка = ПомощникТестированияВызовСервера.НовыйТовар();
	ЮТест.Контекст().Значение("Ссылки").Вставить("ТестВызовСервера", Ссылка);
	
КонецПроцедуры

Процедура УдалениеТестовыхДанныхДокумент(НомерДокумента) Экспорт
	
	ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара")
		.Установить("Номер", НомерДокумента)
		.Провести();
	
КонецПроцедуры

Процедура УдалениеТестовыхДанныхРегистрСведений(Период) Экспорт
	
	ЮТест.ОжидаетЧтоТаблицаБазы("РегистрСведений.КурсыВалют").НеСодержитЗаписи(ЮТест.Предикат().Реквизит("Период").Равно(Период));
	ЮТест.Данные().КонструкторОбъекта("РегистрыСведений.КурсыВалют")
		.Фикция("Валюта")
		.Фикция("Курс")
		.Установить("Период", Период)
		.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередВсемиТестами() Экспорт
	
	Ссылки = Новый Структура("Набор, Тест");
	ЮТест.Контекст().УстановитьЗначение("Ссылки", Ссылки);
	
КонецПроцедуры

Процедура ПередТестовымНабором() Экспорт
	
	СоздатьСсылку("Набор");
	
КонецПроцедуры

Процедура ПослеВсехТестов() Экспорт
	
	Ссылки = ЮТест.Контекст().Значение("Ссылки");
	СсылкаНеСуществует(Ссылки.Набор, "Набор");
	Если Ссылки.Тест <> Неопределено Тогда
		СсылкаНеСуществует(Ссылки.Тест, "Тест");
	КонецЕсли;
	
#Если Сервер Тогда
	СсылкаНеСуществует(Ссылки.ТестВызовСервера, "ТестВызовСервера");
#Иначе
	СсылкаСуществует(Ссылки.ТестВызовСервера, "ТестВызовСервера");
#КонецЕсли
	
КонецПроцедуры

Процедура СоздатьСсылку(ИмяПеременной, Знач Код = Неопределено)
	
	Если Код = Неопределено Тогда
		Код = ЮТОбщий.ЧислоВСтроку(ЮТест.Данные().СлучайноеПоложительноеЧисло(999999999));
	КонецЕсли;
	
	Ссылка = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Установить("Наименование", Код)
		.Установить("Код", Код)
		.Записать();
	ЮТест.Контекст().Значение("Ссылки").Вставить(ИмяПеременной, Ссылка);
	
КонецПроцедуры

Процедура СсылкаСуществует(Ссылка, Описание)
	
	ЮТест.ОжидаетЧто(Ссылка, Описание).ИмеетТип("СправочникСсылка.Товары");
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары", Описание).СодержитЗаписи(ЮТест.Предикат().Реквизит("Ссылка").Равно(Ссылка));
	
КонецПроцедуры

Процедура СсылкаНеСуществует(Ссылка, Описание)
	
	ЮТест.ОжидаетЧто(Ссылка, Описание).ИмеетТип("СправочникСсылка.Товары");
	ЮТест.ОжидаетЧтоТаблицаБазы("Справочник.Товары", Описание).НеСодержитЗаписи(ЮТест.Предикат().Реквизит("Ссылка").Равно(Ссылка));
	
КонецПроцедуры

#КонецОбласти
