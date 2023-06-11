# HardwareStoreDB

## Overview

This repository contains the DDL script for the creation of a PostgreSQL database for a hardware store. The database consists of tables representing customers, suppliers, manufacturers, tools, tool types, and transactions.

## Tables

### Customer

Stores customer data, including first and last names, addresses, rental status, and more.

### Supplier

Keeps track of suppliers' data, such as names, addresses, and contact details.

### Manufacturer

Stores information about manufacturers, such as names, addresses, and contact details.

### Tools

Stores data about tools, such as type, manufacturer, stock status, rental status, and more.

### ToolType

Keeps track of tool types and their specific details.

### Transactions

Stores all transactions conducted in the hardware store.

## Installation

1. Clone this repository using `git clone https://github.com/Sondra94534/HardwareStoreDB.git`
2. Open the PostgreSQL command line interface.
3. Use `\i <path-to-the-repository>/hardware_store_db.sql` to run the DDL script and create the database and tables.

## Usage

Once the database and tables have been created, they can be used to store and manage information for a hardware store. The `hardware_store_db.sql` file contains the DDL statements for creating the database and tables.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.

---

