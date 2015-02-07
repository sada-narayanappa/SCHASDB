\copy hospital( provider_number, name, address_1, address_2, address_3, city, state, zip, county, phone, hospital_type, hospital_ownership, emergency_services, latitude,longitude) FROM 't.csv'  DELIMITERS ',' CSV HEADER;

