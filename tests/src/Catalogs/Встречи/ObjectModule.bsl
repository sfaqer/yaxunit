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

&Вместо("УказанКорректныйПериод")
Функция Расш1_УказанКорректныйПериод()
	
	ПараметрыМетода = Новый Массив();
	
	ПрерватьВыполнение = Ложь;
	Результат = МокитоПерехват.АнализВызова(ЭтотОбъект, "УказанКорректныйПериод", ПараметрыМетода, ПрерватьВыполнение);
	
	Если НЕ ПрерватьВыполнение Тогда
		Возврат ПродолжитьВызов();
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

&Вместо("ПередЗаписью")
Процедура Расш1_ПередЗаписью(Отказ)
	
	ПараметрыМетода = ЮТКоллекции.ЗначениеВМассиве(Отказ);
	
	ПрерватьВыполнение = Ложь;
	МокитоПерехват.АнализВызова(ЭтотОбъект, "ПередЗаписью", ПараметрыМетода, ПрерватьВыполнение);
	
	Если НЕ ПрерватьВыполнение Тогда
		ПродолжитьВызов(Отказ);
	КонецЕсли;
	
КонецПроцедуры
