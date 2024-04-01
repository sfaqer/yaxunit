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

#Область ПрограммныйИнтерфейс

// Создает новый элемент и возвращает его ссылку.
//  
// Параметры:
//  Менеджер - Произвольный - Менеджер справочника/ПВХ и тд.
//  Наименование - Строка, Неопределено - Наименование элемента
//  Реквизиты - Структура, Неопределено - Значения реквизитов элемента
//  ПараметрыЗаписи - см. ЮТОбщий.ПараметрыЗаписи
// 
// Возвращаемое значение:
//  ЛюбаяСсылка - Ссылка на созданный объект
Функция СоздатьЭлемент(Менеджер, Наименование = Неопределено, Реквизиты = Неопределено, Знач ПараметрыЗаписи = Неопределено) Экспорт
	
	Если Реквизиты <> Неопределено Тогда
		Данные = Реквизиты;
	Иначе
		Данные = Новый Структура;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		Если ЮТОбщийСлужебныйВызовСервера.ЭтоАнглийскийВстроенныйЯзык() Тогда
			Данные.Вставить("Description", Наименование);
		Иначе
			Данные.Вставить("Наименование", Наименование);
		КонецЕсли;
	КонецЕсли;
	
	Ссылка = ЮТТестовыеДанныеСлужебныйВызовСервера.СоздатьЗапись(Менеджер, Данные, ПараметрыЗаписи, Ложь);
	ЮТТестовыеДанныеСлужебный.ДобавитьТестовуюЗапись(Ссылка);
	
	Возврат Ссылка;
	
КонецФункции

// Создает новый документ и возвращает его ссылку.
//  
// Параметры:
//  Менеджер - Произвольный - Менеджер справочника/ПВХ и тд.
//  Реквизиты - Структура, Неопределено - Значения реквизитов элемента
//  ПараметрыЗаписи - см. ЮТОбщий.ПараметрыЗаписи
// 
// Возвращаемое значение:
//  ДокументСсылка - Ссылка на созданный объект
Функция СоздатьДокумент(Менеджер, Реквизиты = Неопределено, Знач ПараметрыЗаписи = Неопределено) Экспорт
	
	Если Реквизиты <> Неопределено Тогда
		Данные = Реквизиты;
	Иначе
		Данные = Новый Структура;
	КонецЕсли;
	
	Если ПараметрыЗаписи = Неопределено И Данные.Свойство("РежимЗаписи") Тогда
		ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
		ПараметрыЗаписи.РежимЗаписи = Данные.РежимЗаписи;
		Данные.Удалить("РежимЗаписи");
	КонецЕсли;
	
	Ссылка = ЮТТестовыеДанныеСлужебныйВызовСервера.СоздатьЗапись(Менеджер, Данные, ПараметрыЗаписи, Ложь);
	ЮТТестовыеДанныеСлужебный.ДобавитьТестовуюЗапись(Ссылка);
	
	Возврат Ссылка;
	
КонецФункции

// Создает новую группу
//  
// Параметры:
//  Менеджер - Произвольный - Менеджер справочника/ПВХ и тд.
//  Наименование - Строка, Неопределено - Наименование элемента
//  Реквизиты - Структура, Неопределено - Значения реквизитов элемента
//  ПараметрыЗаписи - см. ЮТОбщий.ПараметрыЗаписи
// 
// Возвращаемое значение:
//  ЛюбаяСсылка - Ссылка на созданную группу
Функция СоздатьГруппу(Менеджер, Наименование = Неопределено, Реквизиты = Неопределено, Знач ПараметрыЗаписи = Неопределено) Экспорт
	
	Если Реквизиты <> Неопределено Тогда
		Данные = Реквизиты;
	Иначе
		Данные = Новый Структура;
	КонецЕсли;
	
	Данные.Вставить("ЭтоГруппа", Истина);
	
	Возврат СоздатьЭлемент(Менеджер, Наименование, Данные, ПараметрыЗаписи);
	
КонецФункции

#Область ГенерацияСлучайныхЗначений

// Генерирует и возвращает случайное число.
// 
// Параметры:
//  Минимум - Неопределено, Число - Минимальное значение
//  Максимум - Неопределено, Число - Максимальное значение
//  ЗнаковПослеЗапятой - Число - Количество знаков после запятой
// 
// Возвращаемое значение:
//  Число - Случайное число
Функция СлучайноеЧисло(Минимум = 0, Максимум = Неопределено, ЗнаковПослеЗапятой = 0) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение ЮТИсключения.МетодНеДоступен("ЮТТестовыеДанные.СлучайноеЧисло");
#Иначе
	Генератор = ЮТКонтекстСлужебный.ЗначениеКонтекста("ГенераторСлучайныхЧисел");
	
	Если Генератор = Неопределено Тогда
		Генератор = Новый ГенераторСлучайныхЧисел();
		ЮТКонтекстСлужебный.УстановитьЗначениеКонтекста("ГенераторСлучайныхЧисел", Генератор);
	КонецЕсли;
	
	Если Максимум = Неопределено Тогда
		Результат = Генератор.СлучайноеЧисло(Минимум);
	Иначе
		Результат = Генератор.СлучайноеЧисло(Минимум, Максимум);
	КонецЕсли;
	
	Если ЗнаковПослеЗапятой > 0 Тогда
		Множитель = Pow(10, ЗнаковПослеЗапятой);
		Результат = Результат + Окр(Генератор.СлучайноеЧисло(0, Множитель) / Множитель, ЗнаковПослеЗапятой);
	КонецЕсли;
	
	Возврат Результат;
#КонецЕсли
	
КонецФункции

// Генерирует и возвращает случайное положительное число.
// 
// Параметры:
//  Максимум - Неопределено, Число - Максимальное значение
//  ЗнаковПослеЗапятой - Число - Знаков после запятой
// 
// Возвращаемое значение:
//  Число - Случайное положительное число
Функция СлучайноеПоложительноеЧисло(Максимум = Неопределено, ЗнаковПослеЗапятой = 0) Экспорт
	
	Возврат СлучайноеЧисло(1, Максимум, ЗнаковПослеЗапятой);
	
КонецФункции

// Генерирует и возвращает случайное отрицательное число.
// 
// Параметры:
//  Минимум - Неопределено, Число - Минимальное значение
//  ЗнаковПослеЗапятой - Число - Знаков после запятой
// 
// Возвращаемое значение:
//  Число - Случайное отрицательное число
Функция СлучайноеОтрицательноеЧисло(Знач Минимум = Неопределено, ЗнаковПослеЗапятой = 0) Экспорт
	
	Если Минимум <> Неопределено Тогда
		Минимум = -Минимум;
	КонецЕсли;
	
	Возврат -СлучайноеЧисло(0, Минимум, ЗнаковПослеЗапятой);
	
КонецФункции

// Генерирует и возвращает случайную строку указанной длины, строка может содержать цифры, английские и русские буквы в разных регистрах.
// 
// Параметры:
//  Длина - Число - Длина генерируемой строки с учетом префикса
//  Префикс - Строка - Префикс строки
//  ДопустимыеСимволы - Строка - Допустимые символы из которая будет формироваться случайная строка
// 
// Возвращаемое значение:
//  Строка - Случайная строка
Функция СлучайнаяСтрока(Знач Длина = 10, Префикс = "", Знач ДопустимыеСимволы = Неопределено) Экспорт
	
	Если ДопустимыеСимволы = Неопределено Тогда
		ДопустимыеСимволы = ЮТСтроки.РусскиеБуквы(Истина, Истина) + ЮТСтроки.АнглийскиеБуквы(Истина, Истина) + ЮТСтроки.Цифры();
	КонецЕсли;
	
	Результат = "";
	КоличествоСимволов = СтрДлина(ДопустимыеСимволы);
	
	Длина = Длина - СтрДлина(Префикс);
	
	Для Инд = 1 По Длина Цикл
		
		Результат = Результат + Сред(ДопустимыеСимволы, СлучайноеЧисло(1, КоличествоСимволов), 1);
		
	КонецЦикла;
	
	Возврат Префикс + Результат;
	
КонецФункции

// Возвращяет случайный валидный идентификатор
// 
// Параметры:
//  Длина - Число - Длина генерируемой строки с учетом префикса
//  Префикс - Строка - Префикс строки
// 
// Возвращаемое значение:
//  Строка - Случайный идентификатор
Функция СлучайныйИдентификатор(Знач Длина = 10, Знач Префикс = "") Экспорт
	
	НаборСимволов = "_" + ЮТСтроки.РусскиеБуквы(Истина, Истина) + ЮТСтроки.АнглийскиеБуквы(Истина, Истина);
	
	Если ПустаяСтрока(Префикс) Тогда
		Префикс = СлучайнаяСтрока(1, "", НаборСимволов);
	КонецЕсли;
	
	НаборСимволов = НаборСимволов + ЮТСтроки.Цифры();
	
	Возврат СлучайнаяСтрока(Длина, Префикс, НаборСимволов);
	
КонецФункции

// Генерирует и возвращает случайную дату в указанном интервале (если не указан используется `0001-01-01  - 3999-12-31`).
// 
// Параметры:
//  Минимум - Дата - Минимальное значение случайной даты
//          - Неопределено - Если не указано используется `0001-01-01`
//  Максимум - Дата - Максимальное значение случайной даты
//           - Неопределено - Если не указано используется `3999-12-31`
// 
// Возвращаемое значение:
//  Дата - Случайная дата
Функция СлучайнаяДата(Знач Минимум = '00010101', Знач Максимум = '39991231') Экспорт
	
	Если Минимум = Максимум Тогда
		Возврат Минимум;
	ИначеЕсли Максимум < Минимум Тогда
		ВызватьИсключение ЮТИсключения.НекорректныеПараметрыМетода("СлучайнаяДата", "максимальное значение должно быть больше минимального");
	КонецЕсли;
	
	РазностьДат = Максимум - Минимум;
	
	Если РазностьДат <= МаксимумГенератора() Тогда
		Возврат Минимум + СлучайноеЧисло(0, РазностьДат);
	КонецЕсли;
	
	СекундВДне = 86400;
	КоличествоДней = Цел((РазностьДат) / СекундВДне);
	
	Возврат Минимум + СлучайноеЧисло(0, КоличествоДней) * СекундВДне + СлучайноеЧисло(0, СекундВДне);
	
КонецФункции

// Генерирует случайное время
// 
// Возвращаемое значение:
//  Дата - Случайное время
Функция СлучайноеВремя() Экспорт
	
	СекундВСутках = 60*60*24;
	
	Возврат '00010101000000' + СлучайноеЧисло(0, СекундВСутках - 1);
	
КонецФункции

// Генерирует случайную дату в будущем.
// Максимальное значение генерируемой даты можно ограничить параметрами.
// Например: СлучайнаяДатаВБудущем(2, "часа") - будет сформирована дата в интервале (ТекущаяДата, ТекущаяДата + 2 часа]
// 
// Параметры:
//  Интервал - Число - Интервал
//  ТипИнтервала - Строка - Строковое представление интервала времени, возможные значения
//                 * секунда, секунды, секунд
//                 * минута, минуты, минут
//                 * час, часа, часов
//                 * день, дня, дней
//                 * месяц, месяца, месяцев
// 
// Возвращаемое значение:
//  Дата - Случайная дата в будущем
Функция СлучайнаяДатаВБудущем(Интервал = Неопределено, ТипИнтервала = Неопределено) Экспорт
	
	//@skip-check use-non-recommended-method
	Возврат СлучайнаяДатаПосле(ТекущаяДата(), Интервал, ТипИнтервала);
	
КонецФункции

// Генерирует случайную дату в прошлом.
// Минимальное значение генерируемой даты можно ограничить параметрами.
// Например: СлучайнаяДатаВПрошлом(2, "часа") - будет сформирована дата в интервале [ТекущаяДата - 2 часа, ТекущаяДата)
// 
// Параметры:
//  Интервал - Число - Интервал
//  ТипИнтервала - Строка - Строковое представление интервала времени, возможные значения
//                 * секунда, секунды, секунд
//                 * минута, минуты, минут
//                 * час, часа, часов
//                 * день, дня, дней
//                 * месяц, месяца, месяцев
// 
// Возвращаемое значение:
//  Дата - Случайная дата в прошлом
Функция СлучайнаяДатаВПрошлом(Интервал = Неопределено, ТипИнтервала = Неопределено) Экспорт
	
	//@skip-check use-non-recommended-method
	Возврат СлучайнаяДатаДо(ТекущаяДата(), Интервал, ТипИнтервала);
	
КонецФункции

// Генерирует случайную дату, значение которой больше указанной.
// Максимальное значение генерируемой даты можно ограничить параметрами.
// Например: СлучайнаяДатаПосле(Дата, 2, "часа") - будет сформирована дата в интервале [Дата - 2 часа, Дата)
// 
// Параметры:
//  Дата - Дата
//  Интервал - Число - Интервал
//  ТипИнтервала - Строка - Строковое представление интервала времени, возможные значения
//                 * секунда, секунды, секунд
//                 * минута, минуты, минут
//                 * час, часа, часов
//                 * день, дня, дней
//                 * месяц, месяца, месяцев
// 
// Возвращаемое значение:
//  Дата
Функция СлучайнаяДатаПосле(Дата, Интервал = Неопределено, ТипИнтервала = Неопределено) Экспорт
	
	ИнтервалНеУказан = Интервал = Неопределено И ТипИнтервала = Неопределено;
	
	Если ИнтервалНеУказан Тогда
		Возврат СлучайнаяДата(Дата + 1);
	Иначе
		Минимум = Дата + 1;
		Максимум = ЮТОбщий.ДобавитьКДате(Дата, Интервал, ТипИнтервала);
		Возврат СлучайнаяДата(Минимум, Максимум);
	КонецЕсли;
	
КонецФункции

// Генерирует случайную дату, значение которой меньше указанной.
// Минимальное значение генерируемой даты можно ограничить параметрами.
// Например: СлучайнаяДатаПосле(Дата, 2, "часа") - будет сформирована дата в интервале [Дата - 2 часа, Дата)
// 
// Параметры:
//  Дата - Дата
//  Интервал - Число - Интервал
//  ТипИнтервала - Строка - Строковое представление интервала времени, возможные значения
//                 * секунда, секунды, секунд
//                 * минута, минуты, минут
//                 * час, часа, часов
//                 * день, дня, дней
//                 * месяц, месяца, месяцев
// 
// Возвращаемое значение:
//  Дата
Функция СлучайнаяДатаДо(Дата, Интервал = Неопределено, ТипИнтервала = Неопределено) Экспорт
	
	ИнтервалНеУказан = Интервал = Неопределено И ТипИнтервала = Неопределено;
	
	Если ИнтервалНеУказан Тогда
		Возврат СлучайнаяДата(, Дата - 1);
	Иначе
		Минимум = ЮТОбщий.ДобавитьКДате(Дата, -Интервал, ТипИнтервала);
		Максимум = Дата - 1;
		Возврат СлучайнаяДата(Минимум, Максимум);
	КонецЕсли;
	
КонецФункции

// Генерирует и возвращает случайный IP адрес.
// 
// Возвращаемое значение:
//  Строка - Случайный IP адрес
Функция СлучайныйIPАдрес() Экспорт
	
	Части = Новый Массив();
	Части.Добавить(СлучайноеЧисло(1, 253));
	Части.Добавить(СлучайноеЧисло(1, 253));
	Части.Добавить(СлучайноеЧисло(1, 253));
	Части.Добавить(СлучайноеЧисло(1, 253));
	
	Возврат СтрСоединить(Части, ".");
	
КонецФункции

// Возвращает случайный элемент списка.
// 
// Параметры:
//  Список - Массив из Произвольный - Коллекция возможных значений
// 
// Возвращаемое значение:
//  Произвольный - случайное значение из списка
Функция СлучайноеЗначениеИзСписка(Список) Экспорт
	
	Индекс = СлучайноеЧисло(0, Список.ВГраница());
	
	Возврат Список[Индекс];
	
КонецФункции

// Возвращает случайное логическое значение.
// 
// Возвращаемое значение:
//  Булево - Случайное булево
Функция СлучайноеБулево() Экспорт
	
	Возврат СлучайноеЧисло() % 2 = 0;
	
КонецФункции

// Возвращает случайное значение перечисления
// 
// Параметры:
//  Перечисление - ПеречислениеМенеджер - Менеджер
//               - Строка - Имя объекта метаданных
// 
// Возвращаемое значение:
//  ПеречислениеСсылка
Функция СлучайноеЗначениеПеречисления(Перечисление) Экспорт
	
	Возврат ЮТТестовыеДанныеСлужебныйВызовСервера.СлучайноеЗначениеПеречисления(Перечисление);
	
КонецФункции

// Возвращает случайное предопреленное значения объекта конфигурации.
// 
// Параметры:
//  Менеджер - Строка - Имя менеджера. Примеры: "Справочники.ВидыЦен", "Справочник.ВидыЦен"
//           - Произвольный - Менеджер объекта метаданных. Примеры: Справочники.ВидыЦен
//  Отбор - Структура, Соответствие из Произвольный - Отбора поиска предопределенных значений (сравнение на равенство)
// 
// Возвращаемое значение:
//  ПеречислениеСсылка
Функция СлучайноеПредопределенноеЗначение(Менеджер, Отбор = Неопределено) Экспорт
	
	Возврат ЮТТестовыеДанныеСлужебныйВызовСервера.СлучайноеПредопределенноеЗначение(Менеджер, Отбор);
	
КонецФункции

// Возвращает случайный номер телефона.
// 
// Параметры:
//  КодСтраны - Строка - Код страны, с которого будет начинаться номер.
// 
// Возвращаемое значение:
//  Строка -  Сгенерированный номер телефона.
Функция СлучайныйНомерТелефона(КодСтраны = "7") Экспорт
	Результат = СтрШаблон(
		"+%1(%2)%3-%4-%5",
		?(ПустаяСтрока(КодСтраны), "7", КодСтраны),
		Формат(СлучайноеЧисло(0, 999), "ЧЦ=3; ЧН=000; ЧВН=; ЧГ=0;"),
		Формат(СлучайноеЧисло(0, 999), "ЧЦ=3; ЧН=000; ЧВН=; ЧГ=0;"),
		Формат(СлучайноеЧисло(0, 99), "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0;"),
		Формат(СлучайноеЧисло(0, 99), "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0;")
	);
	
	Возврат Результат;
КонецФункции

#КонецОбласти

// Генерирует и возвращает уникальную строку, формируется из уникального идентификатора.
// 
// Параметры:
//  Префикс - Строка - Префикс строки
// 
// Возвращаемое значение:
//  Строка - Уникальная строка
Функция УникальнаяСтрока(Префикс = "") Экспорт
	
	Возврат Префикс + Новый УникальныйИдентификатор();
	
КонецФункции

#Если Не ВебКлиент Тогда
	
// Создает новый файл, который будет удален после теста
// 
// Параметры:
//  Содержимое - Строка, Неопределено - Содержимое файла
//  ТолькоЧтение - Булево - Установить атрибут `только чтение`
//  Расширение - Строка, Неопределено - Расширение нового файла
// 
// Возвращаемое значение:
//  Строка - Новый файл
Функция НовыйФайл(Содержимое = Неопределено, ТолькоЧтение = Ложь, Расширение = Неопределено) Экспорт
	
	Результат = НовоеИмяВременногоФайла(Расширение);
	
	ЗаписьДанных = Новый ЗаписьДанных(Результат);
	
	Если Содержимое <> Неопределено Тогда
		ЗаписьДанных.ЗаписатьСимволы(Содержимое);
	КонецЕсли;
	
	ЗаписьДанных.Закрыть();
	
	Если ТолькоЧтение Тогда
		СозданныйФайл = Новый Файл(Результат);
		СозданныйФайл.УстановитьТолькоЧтение(Истина);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
	
// Возвращает имя нового файла.
// По окончании выполнения теста этот файл будет удален.
// 
// Параметры:
//  Расширение - Строка - Расширение нового файла
// 
// Возвращаемое значение:
//  Строка
Функция НовоеИмяВременногоФайла(Расширение = Неопределено) Экспорт
	
	Возврат ЮТТестовыеДанныеСлужебный.НовоеИмяВременногоФайла(Расширение);
	
КонецФункции

// Читает таблицу MarkDown в массив структур
// 
// Параметры:
//  Строки - Строка - Таблица markdown
// 
// Возвращаемое значение:
//  Массив  из Структура - Данные таблицы markdown
Функция ТаблицаMarkDown(Строки) Экспорт
	
	ЗагрузилиЗаголовок = Ложь;
	Результат = Новый Массив();
	Ключи = "";
	
	Разделитель = "|";
	
	Кодировка = КодировкаТекста.UTF8;
	Поток = ПолучитьДвоичныеДанныеИзСтроки(Строки, Кодировка).ОткрытьПотокДляЧтения();
	Чтение = Новый ЧтениеТекста(Поток, Кодировка);
	
	Пока Истина Цикл
		
		Строка = Чтение.ПрочитатьСтроку();
		Если Строка = Неопределено Тогда
			Прервать;
		КонецЕсли;
		
		Строка = СокрЛП(Строка);
		
		Если ПустаяСтрока(Строка) Тогда
			Продолжить;
		ИначеЕсли НЕ СтрНачинаетсяС(Строка, Разделитель) Тогда
			Если ЗагрузилиЗаголовок Тогда
				Прервать;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Блоки = СтрРазделить(Строка, Разделитель);
		
		Если ЗагрузилиЗаголовок Тогда
			
			Если Блоки.Количество() <> Ключи.Количество() Тогда
				ВызватьИсключение СтрШаблон("Количество значений в строке (%1) Markdown не совпадает с количеством заголовков (%2):
											|%3", Блоки.Количество(), Ключи.Количество(), Строка);
			КонецЕсли;
			
			СтрокаРезультата = Новый Структура();
			Для Инд = 1 По Блоки.ВГраница() - 1 Цикл
				СтрокаРезультата.Вставить(Ключи[Инд], СокрЛП(Блоки[Инд]));
			КонецЦикла;
			Результат.Добавить(СтрокаРезультата);
		Иначе
			Ключи = Новый Массив();
			Для Инд = 0 По Блоки.ВГраница() Цикл
				Ключи.Добавить(СокрЛП(Блоки[Инд]));
			КонецЦикла;
			Чтение.ПрочитатьСтроку(); // Пропуск строки разделителя
			ЗагрузилиЗаголовок = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Чтение.Закрыть();
	Поток.Закрыть();
	
	Возврат Результат;
	
КонецФункции

// Формирует структуру на основании таблицы Markdown
// 
// Параметры:
//  Ключ - Строка - Имя ключевой колонки
//  Строки - Строка - Таблица markdown
// 
// Возвращаемое значение:
//  Структура
Функция СтруктураMarkDown(Ключ, Строки) Экспорт
	
	Таблица = ТаблицаMarkDown(Строки);
	
	Результат = Новый Структура();
	
	Для Каждого Строка Из Таблица Цикл
		Результат.Вставить(Строка[Ключ], Строка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли

// Формирует массив различных комбиначий параметров
// 
// Предназначено для формирования таблицы возможных значений параметров для краш теста метода.
// 
// Параметры:
//  ЗначенияПоУмолчанию - Структура - Значения параметров по умолчанию.
//  ЗначенияПараметров - Структура - Массивы значений для каждого параметра.
// 
// Возвращаемое значение:
//  Массив из Структура - Варианты параметров.
Функция ВариантыПараметров(ЗначенияПоУмолчанию, ЗначенияПараметров) Экспорт
	
	Варианты = Новый Массив;
	Варианты.Добавить(ЗначенияПоУмолчанию);
	
	Ключи = ЮТКоллекции.ВыгрузитьЗначения(ЗначенияПараметров, "Ключ");
	
	ДобавитьВарианты(Варианты, ЗначенияПоУмолчанию, ЗначенияПараметров, Ключи, 0);
	
	Возврат Варианты;
	
КонецФункции

// Возвращает конструктор создания тестовых данных
// 
// Конструктор имеет ряд особенностей:
// 
// * Нельзя использовать параллельно несколько конструкторов. 
//   Например
//   
//   ```bsl
//   Пользователь = КонструкторОбъекта(Справочники.Пользователи);
//   Документ = КонструкторОбъекта(Документы.Приход);
//   ...
//   Пользователь.Записать();
//   Документ.Провести();
//   ```
//   
// * Создание объекта происходит при вызове методов `Записать` и `Провести`, а создание реквизитов происходит во время вызова методов установки.
// * При использовании на клиенте все значения должны быть сериализуемыми.
// 
// Параметры:
//  Менеджер - Строка - Имя менеджера. Примеры: "Справочники.Товары", "Документы.ПриходТоваров"
//           - Произвольный - Менеджер объекта метаданных. Примеры: Справочники.Товары, Документы.ПриходТоваров
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторТестовыхДанных
Функция КонструкторОбъекта(Менеджер) Экспорт
	
	Возврат ЮТКонструкторТестовыхДанныхСлужебный.Инициализировать(Менеджер);
	
КонецФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение  Тогда
// Возвращает конструктор создания объекта XDTO
// 
// Параметры:
//  ИмяТипа - Строка - Имя типа объекта
//  ПространствоИмен - Строка - Пространство имен типа
//  Фабрика - ФабрикаXDTO - Используемая фабрика XDTO
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор объекта XDTO
Функция КонструкторОбъектаXDTO(ИмяТипа, ПространствоИмен, Фабрика = Неопределено) Экспорт
	
	Обработка = Обработки.ЮТКонструкторОбъектаXDTO.Создать();
	Обработка.Инициализировать(ИмяТипа, ПространствоИмен, Фабрика);
	
	Возврат Обработка;
	
КонецФункции
#КонецЕсли

// Удаляет переданные объекта
// 
// Параметры:
//  Ссылки - Массив из ЛюбаяСсылка
//  Привилегированно - Булево - Выполнить удаление в привилегированном режиме (без учета прав на объекты)
Процедура Удалить(Ссылки, Привилегированно = Ложь) Экспорт

	Если ЗначениеЗаполнено(Ссылки) Тогда
		ЮТТестовыеДанныеСлужебныйВызовСервера.Удалить(Ссылки, Привилегированно);
	КонецЕсли;

КонецПроцедуры

// Возвращает объект подражателя для формирования осмысленных тестовых данных
//
// Возвращаемое значение:
//  ОбщийМодуль - Подражатель
Функция Подражатель() Экспорт
	
	Возврат ЮТПодражательСлужебный.Инициализировать();
	
КонецФункции

// Возвращает таблицу значений из табличного документа
// 
// Параметры:
//  Макет - ТабличныйДокумент - Исходный табличный документ
//  ОписанияТипов - Соответствие из ОписаниеТипов - Соответствие имен колонок таблицы к типам значений
//  КэшЗначений - Соответствие из Произвольный - Соответствие для хранения создаваемых значений
//  ЗаменяемыеЗначения - Соответствие из Произвольный - Значения, использующиеся для замены
//  ПараметрыСозданияОбъектов - см. ЮТФабрика.ПараметрыСозданияОбъектов
// Возвращаемое значение:
//  - ТаблицаЗначений - Для сервера, данные загруженные из макета
//  - Массив из Структура - Для клиента, данные загруженные из макета
Функция ЗагрузитьИзМакета(Макет,
						  ОписанияТипов,
						  КэшЗначений = Неопределено,
						  ЗаменяемыеЗначения = Неопределено,
						  ПараметрыСозданияОбъектов = Неопределено) Экспорт
	
#Если Сервер Тогда
	ТаблицаЗначений = Истина;
#Иначе
	ТаблицаЗначений = Ложь;
#КонецЕсли
	
	Если Макет = Неопределено Тогда
		ВызватьИсключение "Укажите источник данных (Макет)";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОписанияТипов) Тогда
		ВызватьИсключение "Укажите описание загружаемых колонок (ОписанияТипов)";
	КонецЕсли;
	
	ЮТПроверкиСлужебный.ПроверитьТипПараметра(ОписанияТипов, "Структура, Соответствие", "ЮТТестовыеДанные.ЗагрузитьИзМакета", "ОписанияТипов");
	
	Возврат ЮТТестовыеДанныеСлужебный.ЗагрузитьИзМакета(Макет,
														ОписанияТипов,
														КэшЗначений,
														ЗаменяемыеЗначения,
														ПараметрыСозданияОбъектов,
														ТаблицаЗначений);
	
КонецФункции

#Если Сервер Тогда
// Возвращает мок для `HTTPСервисЗапрос`.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТHTTPСервисЗапрос - Мок
Функция HTTPСервисЗапрос() Экспорт
	
	Если ЮТОбщийСлужебныйВызовСервера.ЭтоАнглийскийВстроенныйЯзык() Тогда
		Возврат Обработки.ЮТHTTPServiceRequest.Создать();
	Иначе
		Возврат Обработки.ЮТHTTPСервисЗапрос.Создать();
	КонецЕсли;
	
КонецФункции
#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
// Возвращает мок для ADO.RecordSet.
// 
// Параметры:
//  Колонки - Строка - Имена колонок набора данных, разделенные запятой
//  Описание - Строка - Описание, полезно для отладки и проверки
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТRecordSet - Мок ADO.RecordSet
Функция ADORecordSet(Колонки, Описание = Неопределено) Экспорт
	
	Обработка = Обработки.ЮТRecordSet.Создать();
	Обработка.Описание = Описание;
	Обработка.Инициализировать(Колонки);
	
	Возврат Обработка;
	
КонецФункции
#КонецЕсли

// Устанавливает значение реквизита ссылки
// 
// Параметры:
//  Ссылка - ЛюбаяСсылка
//  ИмяРеквизита - Строка
//  ЗначениеРеквизита - Произвольный
//  ПараметрыЗаписи - см. ЮТФабрикаСлужебный.ПараметрыЗаписи
Процедура УстановитьЗначениеРеквизита(Ссылка, ИмяРеквизита, ЗначениеРеквизита, ПараметрыЗаписи = Неопределено) Экспорт
	
	Значения = Новый Соответствие();
	Значения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
	УстановитьЗначенияРеквизитов(Ссылка, Значения, ПараметрыЗаписи);
	
КонецПроцедуры

// Устанавливает значения реквизитов ссылки.
// 
// Параметры:
//  Ссылка - ЛюбаяСсылка -  Ссылка
//  ЗначенияРеквизитов - Структура, Соответствие из Произвольный -  Значения реквизитов
//  ПараметрыЗаписи - см. ЮТФабрикаСлужебный.ПараметрыЗаписи
Процедура УстановитьЗначенияРеквизитов(Ссылка, ЗначенияРеквизитов, ПараметрыЗаписи = Неопределено) Экспорт
	
	ЮТТестовыеДанныеСлужебныйВызовСервера.УстановитьЗначенияРеквизитов(Ссылка, ЗначенияРеквизитов);
	
КонецПроцедуры

// Генерирует новое значение указанного типа.
//  Если `ОписаниеТипа` содержит несколько типов, то выбирается случайный из них.
// Параметры:
//  ОписаниеТипа - ОписаниеТипов, Тип - Тип значения генерируемого значения
//  РеквизитыЗаполнения - Структура - Значения реквизитов заполнения создаваемого объекта базы
//                      - Неопределено
// 
// Возвращаемое значение:
//  Произвольный - Сгенерированное значение указанного типа
Функция Фикция(ОписаниеТипа, РеквизитыЗаполнения = Неопределено) Экспорт
	
	Возврат ЮТТестовыеДанныеСлужебный.Фикция(ОписаниеТипа, РеквизитыЗаполнения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВарианты(Варианты, БазоваяСтруктура, ЗначенияПараметров, Ключи, Инд)
	
	Если Инд > Ключи.ВГраница() Тогда
		Возврат;
	КонецЕсли;
	
	Ключ = Ключи[Инд];
	Для Каждого Значение Из ЗначенияПараметров[Ключ] Цикл
		
		Вариант = ЮТКоллекции.СкопироватьСтруктуру(БазоваяСтруктура);
		Вариант[Ключ] = Значение;
		Варианты.Добавить(Вариант);
		
		ДобавитьВарианты(Варианты, Вариант, ЗначенияПараметров, Ключи, Инд + 1);
		
	КонецЦикла;

КонецПроцедуры

Функция МножительПериода(ТипИнтервала)
	
	Множители = ЮТСлужебныйПовторногоИспользования.МножителиИнтервалов();
	Возврат Множители[ТипИнтервала];
	
КонецФункции

Функция ЭтоМесяц(ТипИнтервала)
	
	Возврат СтрСравнить(ТипИнтервала, "месяц") = 0
		Или СтрСравнить(ТипИнтервала, "месяца") = 0
		Или СтрСравнить(ТипИнтервала, "месяцев") = 0;
	
КонецФункции

Функция МаксимумГенератора()
	
	Возврат 4294967295;
	
КонецФункции

#КонецОбласти
