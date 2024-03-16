create table if not exists administration_routes
(
    id          int auto_increment
        primary key,
    description text not null
);

create table if not exists customers
(
    id           int auto_increment
        primary key,
    full_name    text not null,
    phone_number text not null,
    address      text not null
);

create table if not exists doctors
(
    id        int auto_increment
        primary key,
    full_name text not null
);

create table if not exists drug_types
(
    id   int auto_increment
        primary key,
    name text not null
);

create table if not exists drug_types_administration_routes
(
    type_id  int not null,
    route_id int not null,
    constraint drug_types_administration_routes_administration_routes_id_fk
        foreign key (route_id) references administration_routes (id),
    constraint drug_types_administration_routes_drug_types_id_fk
        foreign key (type_id) references drug_types (id)
);

create table if not exists drugs
(
    id              int auto_increment
        primary key,
    name            text not null,
    cost            int  not null,
    shelf_life      int  not null,
    critical_amount int  not null,
    type_id         int  not null,
    description     text not null,
    constraint drugs_drug_types_id_fk
        foreign key (type_id) references drug_types (id),
    check (`critical_amount` >= 0),
    check (`cost` > 0),
    check (`shelf_life` > 0)
);

create table if not exists mixture_types
(
    id   int auto_increment
        primary key,
    name text not null
);

create table if not exists mixtures
(
    drug_id         int auto_increment
        primary key,
    solvent         text not null,
    muxture_type_id int  not null,
    constraint mixtures_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint mixtures_mixture_types_id_fk
        foreign key (muxture_type_id) references mixture_types (id)
);

create table if not exists patients
(
    id        int auto_increment
        primary key,
    full_name text not null,
    birthday  date not null
);

create table if not exists pills
(
    drug_id        int not null
        primary key,
    weight_of_pill int not null,
    total_weight   int null,
    constraint pills_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`total_weight` > 0),
    check (`weight_of_pill` > 0)
);

create table if not exists powders
(
    drug_id      int        not null
        primary key,
    is_composite tinyint(1) not null,
    constraint powders_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);

create table if not exists prescriptions
(
    id         int auto_increment
        primary key,
    diagnosis  text not null,
    patient_id int  not null,
    doctor_id  int  not null,
    date       date not null,
    constraint prescriptions_doctors_id_fk
        foreign key (doctor_id) references doctors (id),
    constraint prescriptions_patients_id_fk
        foreign key (patient_id) references patients (id)
);

create table if not exists orders
(
    id                int auto_increment
        primary key,
    prescription_id   int        not null,
    registration_date date       not null,
    appointed_data    date       null,
    obtaining_date    date       null,
    is_paid           tinyint(1) not null,
    customer_id       int        null,
    constraint orders_customers_id_fk
        foreign key (customer_id) references customers (id),
    constraint orders_prescriptions_id_fk
        foreign key (prescription_id) references prescriptions (id)
);

create table if not exists orders_ready_drugs
(
    order_id int not null,
    drug_id  int not null,
    amount   int not null,
    primary key (drug_id, order_id),
    constraint orders_ready_drugs_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint orders_ready_drugs_orders_id_fk
        foreign key (order_id) references orders (id),
    check (`amount` >= 0)
);

create table if not exists orders_waiting_drug_supplies
(
    order_id int not null,
    drug_id  int not null,
    amount   int not null,
    primary key (drug_id, order_id),
    constraint orders_waiting_supplies_list_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint orders_waiting_supplies_list_orders_id_fk
        foreign key (order_id) references orders (id),
    check (`amount` > 0)
);

create table if not exists prescriptions_content
(
    prescription_id         int not null,
    drug_id                 int not null,
    amount                  int not null,
    administration_route_id int not null,
    primary key (prescription_id, drug_id, administration_route_id),
    constraint prescriptions_content_administration_routes_id_fk
        foreign key (administration_route_id) references administration_routes (id),
    constraint prescriptions_content_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint prescriptions_content_prescriptions_id_fk
        foreign key (prescription_id) references prescriptions (id),
    check (`amount` > 0)
);

create table if not exists salves
(
    drug_id          int  not null
        primary key,
    active_substance text not null,
    constraint salves_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);

create table if not exists solutions
(
    drug_id int not null
        primary key,
    dosage  int not null,
    constraint solutions_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check ((0 <= `dosage`) and (`dosage` <= 100))
);

create table if not exists storage_items
(
    id              int auto_increment
        primary key,
    drug_id         int  not null,
    current_amount  int  null,
    original_amount int  not null,
    receipt_date    date not null,
    constraint storage_items_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`current_amount` >= 0),
    check (`original_amount` > 0)
);

create table if not exists reserved_drugs
(
    order_id        int not null,
    storage_item_id int not null,
    drug_amount     int not null,
    primary key (order_id, storage_item_id),
    constraint reserved_drugs_orders_id_fk
        foreign key (order_id) references orders (id),
    constraint reserved_drugs_storage_items_id_fk
        foreign key (storage_item_id) references storage_items (id),
    check (`drug_amount` > 0)
);

create table if not exists suppliers
(
    id           int auto_increment
        primary key,
    name         text not null,
    phone_number text not null
);

create table if not exists supplies
(
    drug_id       int  not null,
    drug_amount   int  not null,
    cost          int  not null,
    id            int auto_increment
        primary key,
    delivery_date date not null,
    supplier_id   int  not null,
    constraint supplies_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint supplies_suppliers_id_fk
        foreign key (supplier_id) references suppliers (id),
    check (`cost` > 0),
    check (`drug_amount` > 0)
);

create table if not exists technologies
(
    id           int auto_increment
        primary key,
    drug_id      int  not null,
    cooking_time int  not null,
    amount       int  not null,
    description  text not null,
    constraint technologies_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`amount` > 0)
);

create table if not exists production
(
    order_id      int not null,
    technology_id int not null,
    amount        int not null,
    constraint production_orders_id_fk
        foreign key (order_id) references orders (id),
    constraint production_technologies_id_fk
        foreign key (technology_id) references technologies (id),
    check (`amount` > 0)
);

create table if not exists technology_components
(
    technology_id    int not null,
    component_id     int not null,
    component_amount int not null,
    primary key (component_id, technology_id),
    constraint technology_components_drugs_id_fk
        foreign key (component_id) references drugs (id),
    constraint technology_components_technologies_id_fk
        foreign key (technology_id) references technologies (id),
    constraint positive_component_amount_check
        check (`component_amount` > 0)
);

create table if not exists tinctures
(
    drug_id  int  not null
        primary key,
    material text not null,
    constraint tinctures_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);
