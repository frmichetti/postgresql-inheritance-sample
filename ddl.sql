create table if not exists base
(
	id serial not null
		constraint base_pk
			primary key,
	created_at timestamp default now() not null,
	deleted_at timestamp,
	updated_at timestamp default now() not null
);

alter table base owner to postgres;

create unique index if not exists base_id_uindex
	on base (id);

CREATE RULE forbidden_insert AS
    ON INSERT TO public.base DO INSTEAD NOTHING;

create trigger set_timestamp
	before update
	on base
	for each row
	execute procedure trigger_set_timestamp();

create table if not exists users
(
	name varchar(255) not null,
	email varchar(255) not null,
	encrypted_password varchar(255) not null
)
inherits (base);

alter table users owner to postgres;

create unique index if not exists users_email_uindex
	on users (email);

create unique index if not exists users_id_uindex
	on users (id);

create trigger set_timestamp
	before update
	on users
	for each row
	execute procedure trigger_set_timestamp();

create table if not exists person
(
	phone varchar(255) not null,
	cpf varchar(255) not null,
	user_id integer
		constraint person_users_id_fk
			references users (id)
				on delete cascade,
	constraint persons_pk
		primary key (id)
)
inherits (base);

alter table person owner to postgres;

create unique index if not exists persons_cpf_uindex
	on person (cpf);

create unique index if not exists persons_id_uindex
	on person (id);

create unique index if not exists persons_user_id_uindex
	on person (user_id);

CREATE RULE forbidden_insert AS
    ON INSERT TO public.person DO INSTEAD NOTHING;

create trigger set_timestamp
	before update
	on person
	for each row
	execute procedure trigger_set_timestamp();

create table if not exists access_tokens
(
	token varchar(255) not null
		constraint access_tokens_pk
			primary key,
	created_at timestamp default now() not null,
	valid_until timestamp default (now() + '1 day'::interval) not null,
	person_id integer not null
);

alter table access_tokens owner to postgres;

create unique index if not exists access_tokens_token_uindex
	on access_tokens (token);

create table if not exists employees
(
	constraint employees_pk
		primary key (id)
)
inherits (base, person);

alter table employees owner to postgres;

create unique index if not exists employees_id_uindex
	on employees (id);

create trigger set_timestamp
	before update
	on employees
	for each row
	execute procedure trigger_set_timestamp();

create table if not exists customers
(
	constraint customers_pk
		primary key (id)
)
inherits (base, person);

alter table customers owner to postgres;

create unique index if not exists customers_id_uindex
	on customers (id);

create trigger set_timestamp
	before update
	on customers
	for each row
	execute procedure trigger_set_timestamp();

