/*DDL script to create a hardware company database. 

@author Sondra Hoffman
@date created 06/06/2021
*/
CREATE DATABASE hardware_store 
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF8'
    LC_CTYPE = 'en_US.UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

--Creates Customer Table--

CREATE TABLE customer (
    cust_id character varying (8) NOT NULL,
    cust_first_name text NOT NULL,
    cust_last_name text NOT NULL,
    cust_street_address text NOT NULL,
    cust_city text NOT NULL,
    cust_state character varying (2) NOT NULL,
    cust_postal_code character varying (10) NOT NULL,
    cust_main_phone character varying (14) NOT NULL,
    cust_rental_status character varying (8) NOT NULL,
    cust_notes character varying (500),
    PRIMARY KEY (cust_id)

);

--Creates Supplier Table--

CREATE TABLE supplier (
    sup_id character varying (8) NOT NULL,
    sup_name text NOT NULL,
    sup_address text NOT NULL,
    sup_city text NOT NULL,
    sup_state character varying (2) NOT NULL,
    sup_postal_code character varying (10) NOT NULL,
    sup_main_phone character varying (14) NOT NULL,
    PRIMARY KEY (sup_id)
)

--Creates Manufacturer Table--

CREATE TABLE manufacturer(
    man_id varchar(8),
    sup_id varchar(8),
    man_name text,
    man_address text,
    man_city text, 
    man_state varchar(2),
    man_postal_code varchar(10),
    man_main_phone varchar(14),
    PRIMARY KEY (man_id),
    FOREIGN KEY (sup_id) REFERENCES supplier(sup_id)
);


--Creates Tools Table--

CREATE TABLE tools (
    tool_id character varying (8) NOT NULL,
    tool_type_id character varying (8),
    man_id character varying (8),
    part_no character varying (25),
    tool_name character varying (25),
    tool_desc character varying (100),
    tool_qoh integer,
    tool_price numeric,
    tool_rental_fee numeric,
    tool_insurance_fee numeric,
    tool_cost numeric,
    tool_stock_status integer,
    tool_rental_status integer,
    PRIMARY KEY (tool_id),
    FOREIGN KEY (man_id) REFERENCES manufacturer(man_id),
    FOREIGN KEY (tool_type_id) REFERENCES tool_type(tool_type_id)
);

--Creates Tool Type Table --

CREATE TABLE tool_type (
    tool_type_id character varying (8),
    power_system character varying (25),
    area_of_use character varying (25),
    PRIMARY KEY (tool_type_id)
);

--Creates Transactions Table--

CREATE TABLE transactions (
    txn_id character varying (8) NOT NULL,
    sup_id character varying (8),
    cust_id character varying (8),
    tool_id character varying (8) NOT NULL,
    order_no character varying (4) NOT NULL,
    txn_line_no integer NOT NULL,
    txn_type character varying (8) NOT NULL,
    txn_date date NOT NULL,
    txn_desc character varying (100),
    txn_uom character varying (2) NOT NULL,
    txn_value money NOT NULL,
    txn_total money,
    PRIMARY KEY (txn_id),
    FOREIGN KEY (sup_id) REFERENCES supplier(sup_id),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id),
    FOREIGN KEY (tool_id) REFERENCES tools(tool_id)
);

--Creates an Index for Manufacturer Name--

CREATE INDEX idx_manufacturer_man_name ON manufacturer(man_name);

--Creates a View of the Tools Along with Manufacturer Details--

CREATE VIEW tool_manufacturer AS
SELECT t.tool_id, t.tool_name, m.man_id, m.man_name
FROM Tools t
JOIN Manufacturer m ON t.man_id = m.man_id;

--A stored procedure to update tools pricing. Use CALL statement to execute.--
CREATE OR REPLACE PROCEDURE update_tool_price(in_tool_id varchar(8), in_new_price numeric)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Tools 
    SET tool_price = in_new_price 
    WHERE tool_id = in_tool_id;
END;
$$;

--After any INSERT or UPDATE of 'tool_stock_status' on  'tools' table, the trigger will be fired and the stored procedure 'update_tool_stock' will be executed.--

CREATE OR REPLACE FUNCTION update_tool_stock() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tool_stock_status < 5 THEN
        RAISE NOTICE 'The stock of tool % is less than 5', NEW.tool_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_tool_stock
AFTER INSERT OR UPDATE OF tool_stock_status ON Tools
FOR EACH ROW EXECUTE PROCEDURE update_tool_stock();
