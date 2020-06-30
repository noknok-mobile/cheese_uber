<?
$MESS["MOBILE_MODULE_FCM"] = "FCM token (для push на Android)";
$MESS["MOBILE_MODULE_LOG"] = "Писать в лог mobileapi.log";
$MESS["MOBILE_MODULE_APNS_CERT"] = "Сертификат APNS";
$MESS["MOBILE_MODULE_APNS_ROOT_CERT"] = "Корневой сертификат APNS";


$MESS["MOBILE_MODULE_INFO"] = "Инструкция";
$MESS["MOBILE_MODULE_INSTALL"] = "Установка модуля";
$MESS["MOBILE_MODULE_INSTALL_TEXT"] = "При установке модуля будут скопированы папка компонента и страница для точки входа запроса.<br>Также будет добавлено новое правило в urlrewrite.php.";
$MESS["MOBILE_MODULE_STRUCT"] = "Структура классов модуля (папка lib)";
$MESS["MOBILE_MODULE_STRUCT_TEXT"] = "<b>ApnsPHP</b> классы для отправки push уведомлений для IOS <br><br>
            <b>authentication</b> классы для авторизации через соцсети <br><br>
            <b>controller</b> содержит классы для работы с запросами, под каждый запрос создается свой класс <br><br>
            <b>general</b> содержит классы c общими методами для контроллеров, обработчики событий <br><br>
            <b>push</b> содержит классы для работы с push уведомелениями IOS / Android <br><br>
            <b>Respect</b> содержит классы для ротутинга (обработка адресов и параметров) <br><br>
            <b>application</b> основной класс приложения, точка входа <br><br>
            <b>logger</b> класс логирования, при включеной опции в настройках модуля включается отладка <br><br>
            <b>mobiletoken, mobileusertoken</b> классы для хранения токенов авторизации для приложения, для хранения токенов устройств(для push) <br><br>
            <b>usersoc</b> класс для хранения авторизации ч/з соцсеть";
$MESS["MOBILE_MODULE_AUTH"] = "Авторизация";
$MESS["MOBILE_MODULE_AUTH_TEXT"] = "platform - тип устройства (для push уведомлений)<br><br>
            token - уникальный id устройства (для push уведомлений)<br><br>
            email - почта, используется в качестве логина, если не<br><br>
            social_token - одноразовый токен пользователя соцсети<br><br>";
$MESS["MOBILE_MODULE_AUTH_TEXT_2"] = "<p>Авторизация через соц. сети осуществляется следующим образом:</p>
            <ul>
                <li>Клиент отправляет запрос на получение данных по соцсети(2 вариант запроса), в ответ получает secret и client_id.</li>
                <li>С помощью этихз данных авторизует пользователя и получает access_token(одноразовый токен для входа в систему).</li>
                <li>Передает токен на сервер(3 вариант запроса).</li>

                <li>Сервер получив данные одноразового токена подтягивает данные из соцсети.</li>
                <li>Осуществляется проверка существования пользователя(на основе таблицы simbirsoft_mobile_usersoc).</li>
                <li>Если такой пользователь существует - авторизуем, если нет - регистрируем, добавляем запись в таблицу simbirsoft_mobile_usersoc, авторизуем пользователя, записываем данные и фото в профиль, которые смогли взять из соцсети (почта и телефон недоступны).</li>
            </ul>
            <br><br>
            <p>В случае успешной авторизации придет ответ вида: </p> <span style='color: green'>{'id':'5','refresh_token':'173c4965f10f30b2e9504f6ed3b2c9c5','token':'2fcdcceb230601a2aada3ff8f41477e3'}</span><p>добавятся записи в таблицы simbirsoft_mobile_user_token(данные по токенам и привязки к пользователям), simbirsoft_mobile_mobile_token(данные по идентификаторам устройств, для рассылки push уведомлений)</p>
            <p>В дальнейшем токен передается в заголовках. <br><span style='color:red'>Важно: </span>если токен истек и был прислан на сервер, ответ от сервера будет 401 ошибка.</p>
            <p>Проверить токен можно в таблице simbirsoft_mobile_user_token, 'EXPIRATION_DATE'.</p>";
$MESS["MOBILE_MODULE_REGISTER"] = "Регистрация";
$MESS["MOBILE_MODULE_REGISTER_TEXT"] = " <p>Запрос на адрес /mobileapp/api/register<br>
            В случае успешной регистрации, сервер авторизует пользователя. <br>
            Ответ от сервера аналогичен авторизации:
            </p>
            <span style='color: green'>{'id': '31', 'refresh_token': '5d174d021beb5d5735eb6e5058d08b09', 'token': 'bcb4843efdefdd7a892386fba6030e78'}</span>
            <p>В случае ошибки:</p>
            <span style='color: orangered'>{'errors': [{'code': '0x022', 'key': 'login', 'message': 'Пользователь с таким email уже зарегистрирован'}]}</span>";
$MESS["MOBILE_MODULE_PROFILE"] = "Профиль";
$MESS["MOBILE_MODULE_PROFILE_TEXT"] = "<p>Токен авторизации передается в заголовках запроса, тип запроса/ответа - json.</p>
            <p>Редактирование профиля происходит в 2 этапа:</p>
            <ul>
                <li>запрос на добавление фото - тип запроса form-data</li>
                <li>запрос на изменение полей - form-urlencoded</li>
            </ul>
            <p>Разделение запросов связано с особенностями отправки запроса в android, не получается все данные отправить через form-data, фото отправляется как и положено, а остальные поля получают тип application/json.</p>";
$MESS["MOBILE_MODULE_IB"] = "Произвольные данные ИБ";
$MESS["MOBILE_MODULE_IB_TEXT"] = "<p>Запрос на адрес /mobileapp/api/elements</p>
            <p>
                {
                'code': 'news_ru',
                'type': 'content',
                'id': 1
                }
            </p>
            <p>$code - код ИБ, $type - тип инфоблока, $id - id нужной записи, если null - будут выбраны все записи</p>
            <p>В классе /local/modules/simbirsoft.mobile/lib/controller/ssIblockelementcontroller.php можно изменить порядок выборки, выбираемые поля, изменив соответственно $arOrder, $arFilter, $arSelect</p>";
$MESS["MOBILE_MODULE_NEW_REQUEST"] = "Создание нового запроса";
$MESS["MOBILE_MODULE_NEW_REQUEST_TEXT"] = "<p>Для создание запроса лучше всего скопировать один из существующих (н-р /local/modules/simbirsoft.mobile/lib/controller/ssIblockelementcontroller.php), переименовать файл и класс.</p>
            <p>Добавить новый запрос в приложение - /local/modules/simbirsoft.mobile/lib/application.php </p>";
$MESS["MOBILE_MODULE_NEW_REQUEST_TEXT_2"] = " <p>Где ключ - адрес запроса (полный путь будет выглядень как URL сайта + '/mobileapp/api' + ключ из указанных массивов), н-р: http://module.loc/mobileapp/api/elements</p>
            <p>$controllersSign - содержит запросы, для которых обязательно наличие токена в заголовках, т.к. в таких запросах обязательно идентифицировать пользоватля(н-р: получить данные профиля, данные заказов и т.д.)<br><span style='color:red'>Важно: </span>: если токен истек и был прислан на сервер, ответ от сервера будет 401 ошибка.</p>";
$MESS["MOBILE_MODULE_TOKENS"] = "Работа с токенами";
$MESS["MOBILE_MODULE_TOKENS_TEXT"] = "<p>При успешной авторизации приходит ответ вида <span style='color: green'>{'id': '31', 'refresh_token': '5d174d021beb5d5735eb6e5058d08b09', 'token': 'bcb4843efdefdd7a892386fba6030e78'}</span></p>
            <p>При запросах, требующих авторизации токен(token) передается в заголовках Token : (token)</p>
            <p>Если срок действия токена истек (24 часа), ответ от сервера будет 401, в такой ситуации нужно выполнить запрос на /refreshtoken, где в теле запроса нужно передать {'refresh_token' : '(token)'}</p>
            <p>Если срок действия не истек, в ответ придет новая пара token / refresh_token.</p>
            <p>В случае, если и refresh_token истек, ответ от сервера будет 401, нужно заного запрашивать авторизацию от сервера.</p>";