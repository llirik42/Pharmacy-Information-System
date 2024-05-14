create table if not exists administration_routes
(
    id          int auto_increment
        primary key,
    description varchar(256) not null,
    constraint description
        unique (description)
);

create table if not exists drug_types
(
    id       int auto_increment
        primary key,
    name     varchar(256) not null,
    cookable tinyint(1)   not null,
    constraint name
        unique (name)
);

create table if not exists mixture_types
(
    id   int auto_increment
        primary key,
    name varchar(256) not null,
    constraint name
        unique (name)
);

create table if not exists customers
(
    id           int auto_increment
        primary key,
    full_name    varchar(256) not null,
    phone_number varchar(32)  not null,
    address      varchar(256) not null,
    constraint full_name
        unique (full_name, phone_number, address)
);

create table if not exists doctors
(
    id        int auto_increment
        primary key,
    full_name varchar(256) not null,
    constraint full_name
        unique (full_name)
);

create table if not exists lab_workers
(
    id        int auto_increment
        primary key,
    full_name varchar(256) not null,
    constraint full_name
        unique (full_name)
);

create table if not exists patients
(
    id        int auto_increment
        primary key,
    full_name varchar(256) not null,
    birthday  date         not null,
    constraint full_name
        unique (full_name, birthday)
);

create table if not exists suppliers
(
    id           int auto_increment
        primary key,
    name         varchar(256) not null,
    phone_number varchar(32)  not null,
    constraint name
        unique (name, phone_number)
);

create table if not exists drugs
(
    id              int auto_increment
        primary key,
    name            varchar(256) not null,
    cost            int          not null,
    shelf_life      int          not null,
    critical_amount int          not null,
    type_id         int          not null,
    description     varchar(256) not null,
    constraint name
        unique (name),
    constraint drugs_drug_types_id_fk
        foreign key (type_id) references drug_types (id),
    check (`cost` > 0),
    check (`shelf_life` > 0),
    check (`critical_amount` >= 0)
);

create table if not exists mixtures
(
    drug_id         int          not null
        primary key,
    solvent         varchar(256) not null,
    mixture_type_id int          not null,
    constraint mixtures_ibfk_1
        foreign key (drug_id) references drugs (id),
    constraint mixtures_ibfk_2
        foreign key (mixture_type_id) references mixture_types (id)
);

create table if not exists tinctures
(
    drug_id  int          not null
        primary key,
    material varchar(256) not null,
    constraint tinctures_ibfk_1
        foreign key (drug_id) references drugs (id)
);

create table if not exists pills
(
    drug_id        int not null
        primary key,
    weight_of_pill int not null,
    pills_count    int not null,
    constraint pills_ibfk_1
        foreign key (drug_id) references drugs (id),
    check (`pills_count` > 0),
    check (`weight_of_pill` > 0)
);

create table if not exists powders
(
    drug_id   int        not null
        primary key,
    composite tinyint(1) not null,
    constraint powders_ibfk_1
        foreign key (drug_id) references drugs (id)
);

create table if not exists salves
(
    drug_id          int          not null
        primary key,
    active_substance varchar(256) not null,
    constraint salves_ibfk_1
        foreign key (drug_id) references drugs (id)
);

create table if not exists solutions
(
    drug_id int not null
        primary key,
    dosage  int not null,
    constraint solutions_ibfk_1
        foreign key (drug_id) references drugs (id),
    check ((0 <= `dosage`) and (`dosage` <= 100))
);

create table if not exists drug_types_administration_routes
(
    type_id  int not null,
    route_id int not null,
    primary key (type_id, route_id),
    constraint drug_types_administration_routes_ibfk_1
        foreign key (route_id) references administration_routes (id),
    constraint drug_types_administration_routes_ibfk_2
        foreign key (type_id) references drug_types (id)
);

create table if not exists prescriptions
(
    id         int auto_increment
        primary key,
    diagnosis  varchar(512) not null,
    patient_id int          not null,
    doctor_id  int          not null,
    date       date         not null,
    constraint diagnosis
        unique (diagnosis, patient_id, doctor_id, date),
    constraint prescriptions_ibfk_1
        foreign key (doctor_id) references doctors (id),
    constraint prescriptions_ibfk_2
        foreign key (patient_id) references patients (id)
);

create table if not exists orders
(
    id                    int auto_increment
        primary key,
    prescription_id       int        not null,
    registration_datetime datetime   not null,
    appointed_datetime    datetime   null,
    obtaining_datetime    datetime   null,
    paid                  tinyint(1) not null,
    customer_id           int        null,
    constraint orders_ibfk_1
        foreign key (customer_id) references customers (id),
    constraint orders_ibfk_2
        foreign key (prescription_id) references prescriptions (id)
);

create table if not exists storage_items
(
    id               int auto_increment
        primary key,
    drug_id          int      not null,
    available_amount int      not null,
    original_amount  int      not null,
    receipt_datetime datetime not null,
    constraint storage_items_ibfk_1
        foreign key (drug_id) references drugs (id),
    check (`available_amount` >= 0),
    check (`original_amount` > 0)
);

create table if not exists supplies
(
    id                int auto_increment
        primary key,
    drug_id           int      not null,
    drug_amount       int      not null,
    cost              int      not null,
    assigned_datetime datetime not null,
    delivery_datetime datetime null,
    supplier_id       int      not null,
    constraint supplies_ibfk_1
        foreign key (drug_id) references drugs (id),
    constraint supplies_ibfk_2
        foreign key (supplier_id) references suppliers (id),
    check (`cost` >= 0),
    check (`drug_amount` > 0)
);

create table if not exists technologies
(
    id           int auto_increment
        primary key,
    drug_id      int          not null,
    cooking_time time         not null,
    amount       int          not null,
    description  varchar(256) not null,
    constraint technologies_ibfk_1
        foreign key (drug_id) references drugs (id),
    check (`amount` > 0)
);

create table if not exists prescriptions_content
(
    prescription_id         int not null,
    drug_id                 int not null,
    amount                  int not null,
    administration_route_id int not null,
    primary key (prescription_id, drug_id, amount, administration_route_id),
    constraint prescriptions_content_ibfk_1
        foreign key (administration_route_id) references administration_routes (id),
    constraint prescriptions_content_ibfk_2
        foreign key (drug_id) references drugs (id),
    constraint prescriptions_content_ibfk_3
        foreign key (prescription_id) references prescriptions (id),
    check (`amount` > 0)
);

create table if not exists production
(
    id            int auto_increment
        primary key,
    order_id      int      not null,
    technology_id int      not null,
    drug_amount   int      not null,
    start         datetime null,
    end           datetime null,
    constraint production_ibfk_1
        foreign key (order_id) references orders (id),
    constraint production_ibfk_2
        foreign key (technology_id) references technologies (id),
    check (((`start` is null) and (`end` is null)) or (`end` is null) or (`end` >= `start`)),
    check (`drug_amount` > 0)
);

create table if not exists orders_waiting_drug_supplies
(
    order_id int not null,
    drug_id  int not null,
    amount   int not null,
    primary key (order_id, drug_id),
    constraint orders_waiting_drug_supplies_ibfk_1
        foreign key (drug_id) references drugs (id),
    constraint orders_waiting_drug_supplies_ibfk_2
        foreign key (order_id) references prescriptions (id),
    check (`amount` > 0)
);

create table if not exists reserved_drugs
(
    order_id        int not null,
    storage_item_id int not null,
    drug_amount     int not null,
    primary key (order_id, storage_item_id),
    constraint reserved_drugs_ibfk_1
        foreign key (order_id) references orders (id),
    constraint reserved_drugs_ibfk_2
        foreign key (storage_item_id) references storage_items (id),
    check (`drug_amount` > 0)
);

create table if not exists production_lab_workers
(
    production_id int not null,
    lab_worker_id int not null,
    primary key (production_id, lab_worker_id),
    constraint production_lab_workers_ibfk_1
        foreign key (lab_worker_id) references lab_workers (id),
    constraint production_lab_workers_ibfk_2
        foreign key (production_id) references production (id)
);

create table if not exists technology_components
(
    technology_id    int not null,
    component_id     int not null,
    component_amount int not null,
    primary key (technology_id, component_id),
    constraint technology_components_ibfk_1
        foreign key (component_id) references drugs (id),
    constraint technology_components_ibfk_2
        foreign key (technology_id) references technologies (id),
    check (`component_amount` > 0)
);
