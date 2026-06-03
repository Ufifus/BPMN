workspace "Архитектура модуля телемедицинских консультаций для МИС" "L1 C4/Structurizr модель модуля телемедицинских консультаций, соответствующая верхнеуровневому BPMN-процессу." {

    !identifiers hierarchical

    model {
        patient = person "Пациент" "Запрашивает телемедицинскую консультацию, выбирает слот и получает заключение."
        doctor = person "Врач" "Проводит видеоконсультацию, оформляет заключение, назначения и рекомендации."
        operator = person "Регистратор / оператор" "Сопровождает расписание и спорные случаи записи."

        telemedicine = softwareSystem "Модуль телемедицинских консультаций" "Подсистема МИС, которая управляет заявками, сеансами, документированием и публикацией результатов телемедицинских консультаций." {
            tags "Core"

            patientPortal = container "Личный кабинет пациента" "Позволяет подать заявку, дать согласия, выбрать слот и получить материалы консультации." "Web/Mobile UI"
            doctorWorkspace = container "АРМ врача" "Позволяет врачу принять пациента, провести консультацию и оформить медицинское заключение." "Web UI"
            consultationApi = container "API и оркестратор консультаций" "Проверяет заявки, создает телемедицинские случаи, координирует подготовку сеанса и публикацию результатов." "Application service" {
                tags "Core"
            }
            videoAdapter = container "Адаптер видеоплатформы" "Резервирует видеокомнату, формирует ссылки доступа и управляет техническими параметрами сеанса." "Integration adapter"
            notificationAdapter = container "Адаптер уведомлений" "Готовит приглашения, напоминания и уведомления о готовности заключения." "Integration adapter"
            telemedicineDb = container "База данных телемедицины" "Хранит заявки, статусы консультаций, ссылки на сеансы, технические события и служебные атрибуты." "Relational database" {
                tags "Database"
            }
            auditLog = container "Журнал аудита" "Фиксирует юридически значимые действия пациента, врача и сервисов модуля." "Audit storage" {
                tags "Database"
            }
        }

        misCore = softwareSystem "Ядро МИС" "Расписание, регистратура, карточка пациента и базовые справочники медицинской организации." {
            tags "MIS"
        }
        ehr = softwareSystem "ЭМК МИС" "Электронная медицинская карта, протоколы консультаций и медицинские документы." {
            tags "MIS"
        }
        billing = softwareSystem "Оплата / ОМС" "Проверка права на услугу, статусы оплаты, ДМС/ОМС и финансовое закрытие случая." {
            tags "External"
        }
        videoPlatform = softwareSystem "Видеоплатформа" "Внешний или корпоративный сервис видеосвязи для проведения консультации." {
            tags "External"
        }
        notificationGateway = softwareSystem "Шлюз уведомлений" "SMS, email, push или мессенджеры для доставки приглашений и статусов." {
            tags "External"
        }

        patient -> telemedicine "Подает заявку, выбирает слот и получает заключение"
        doctor -> telemedicine "Проводит консультацию и оформляет заключение"
        operator -> misCore "Сопровождает расписание и запись"
        telemedicine -> misCore "Создает запись на прием и синхронизирует расписание"
        telemedicine -> ehr "Сохраняет протокол, заключение и назначения"
        telemedicine -> billing "Проверяет право на услугу и обновляет статус оплаты/ОМС"
        telemedicine -> videoPlatform "Резервирует видеокомнату и получает ссылку доступа"
        telemedicine -> notificationGateway "Отправляет приглашения, напоминания и уведомления"

        patient -> telemedicine.patientPortal "Работает с заявкой и результатами консультации"
        doctor -> telemedicine.doctorWorkspace "Проводит прием и документирует результат"
        telemedicine.patientPortal -> telemedicine.consultationApi "Передает заявку, согласия и выбранный слот" "HTTPS/JSON"
        telemedicine.doctorWorkspace -> telemedicine.consultationApi "Получает карточку консультации и отправляет заключение" "HTTPS/JSON"
        telemedicine.consultationApi -> telemedicine.telemedicineDb "Читает и записывает состояние заявок и консультаций"
        telemedicine.consultationApi -> telemedicine.auditLog "Записывает аудит действий и системных событий"
        telemedicine.consultationApi -> misCore "Проверяет пациента, создает запись и обновляет расписание" "Internal API"
        telemedicine.consultationApi -> ehr "Передает протокол, назначения и заключение" "Internal API"
        telemedicine.consultationApi -> billing "Проверяет право на услугу и закрывает финансовый статус" "Internal API"
        telemedicine.consultationApi -> telemedicine.videoAdapter "Запрашивает подготовку видеосеанса"
        telemedicine.videoAdapter -> videoPlatform "Резервирует комнату и получает ссылку" "API"
        telemedicine.consultationApi -> telemedicine.notificationAdapter "Передает события для уведомления участников"
        telemedicine.notificationAdapter -> notificationGateway "Отправляет сообщения пациенту и врачу" "API"
    }

    views {
        systemContext telemedicine "TelemedicineConsultationL1Context" {
            include *
            autoLayout lr
        }

        container telemedicine "TelemedicineConsultationL1Containers" {
            include *
            autoLayout lr
        }

        styles {
            element "Element" {
                color #1f2937
                stroke #1f2937
                strokeWidth 3
                shape roundedbox
            }
            element "Person" {
                shape person
                background #dbeafe
                color #1e3a8a
                stroke #1e40af
            }
            element "Core" {
                background #f97316
                color #ffffff
                stroke #c2410c
            }
            element "MIS" {
                background #e0f2fe
                color #0c4a6e
                stroke #0284c7
            }
            element "External" {
                background #f3f4f6
                color #374151
                stroke #6b7280
            }
            element "Database" {
                shape cylinder
                background #ecfccb
                color #365314
                stroke #65a30d
            }
            element "Boundary" {
                strokeWidth 4
            }
            relationship "Relationship" {
                thickness 3
                color #4b5563
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}
