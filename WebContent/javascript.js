// Упрощаем получение документа
function d(el) {
	return document.getElementById(el);
} 

// Функция для закрытия модального окна. Code: href="javascript:close_modal()"
function close_modal() {
	d('modal_open').style.display = 'none'; // Скрыть модальное окно
	d('modal_open').innerHTML = ''; // Удалить контент  в модальном окне
	d('modal').style.display = 'none'; // Скрыть серый фон со страницы
}

// Функция для открытия модального окна. Code: href="javascript:open_modal(el,w,h)"
function open_modal(el,w,h) {
	d('modal').style.display = 'block'; // Нанести серый фон на страницу
	d('modal_open').style.marginTop = '-'+h+'px'; // h - Певерместить окно вверх, прописываеться в пикселях
	d('modal_open').style.marginLeft = '-'+w+'px'; // w - Певерместить окно влево, прописываеться в пикселях
	d('modal_open').style.display = 'block'; // Показать модальное окно
	d('modal_open').innerHTML = document.getElementById(el).innerHTML; // Вывести в модальном окне содержимое элемента "el"
}