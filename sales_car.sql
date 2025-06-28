#BUAT SCHEMA DB
CREATE SCHEMA sales_car_db; 

#PANGGIL DB YANG TADI DI BUAT
USE sales_car_db;
SHOW TABLES;

# BUAT TABLE sales_car
# karena datanya saya ambil dari kagle jadi columnnya dibuat sesuai data tersebut
CREATE TABLE sales_car (
    `year` INT, #ini menggunakan ` karena nanti year disamakan dengan bahasa sql
    make VARCHAR(200),
    model VARCHAR(200),
    trim VARCHAR(200),
    body VARCHAR(200),
    transmission VARCHAR(200),
    vin VARCHAR(200),
    state VARCHAR(200),
    `condition` INT,
    odometer INT,
    color VARCHAR(200),
    interior VARCHAR(200),
    seller VARCHAR(200),
    mmr INT, #mmr itu harga standard pasar
    sellingprice INT,
    saledate DATE
);

# PANGGIL TABLE YANG TADI DIBUAT
SELECT * FROM sales_car;

# IMPORT DATANYA DARI FILE YANG DI DOWNLOAD DARI KAGLE
#sebelum mengimport kita lihat 'secure_file_priv' ini untuk menaruh data yg direkomendasikan sql agar saat import data aman
SHOW VARIABLES LIKE 'secure_file_priv';
#lalu pindahkan file sales_car.csv di folder C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\sales_car.csv

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_car.csv"
INTO TABLE sales_car
FIELDS TERMINATED BY ',' # menandakan bahwa setiap column di file csv dipisahkan coma
ENCLOSED BY '"' # menunjukan bahwa setiap nilai di dalam column di bungkus "" cth: "KIA"
LINES TERMINATED BY '\n' #menujukan bahwa setiap baris di file csv dipisahkan oleh newline \n
IGNORE 1 ROWS; #mengabaikan baris pertama karena file csv baris pertama itu nama column

# LIHAT TABLE 
SELECT * FROM sales_car;

# INI UNTUK MENGUPDATE BANYAK BARIS
#mengubah value column interior
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_car
SET interior = 'white-glossy'
WHERE interior = '—';
SET SQL_SAFE_UPDATES = 1;

#mengubah value column color
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_car
SET color = 'white-glossy'
WHERE color = '—';
SET SQL_SAFE_UPDATES = 1;

# MENCARI JUMLAH MEREK MOBIL YG ADA DI DATA
SELECT COUNT(DISTINCT make) as jumlah_merek_mobil FROM sales_car;

# MELIHAT MERK APA SAJA YG ADA DI DATA
SELECT DISTINCT make as merek_mobil FROM sales_car #distinct itu untuk menghilangkan data duplikat
ORDER BY make ASC;

# MELIHAT MEREK MOBIL TERMAHAL TOP 3 BEDASARKAN HARGA STANDAR PASAR
with top_3 AS (
		SELECT make, MAX(mmr)  as top_3_mmr
        FROM sales_car
        GROUP BY make
        ORDER BY top_3_mmr DESC
        LIMIT 3 
)
SELECT * FROM top_3;

# MELIHAT MEREK MOBIL TEMURAH TOP 3 BEDASARKAN HARGA STANDAR PASAR
with top_3 AS (
		SELECT make, MAX(mmr)  as top_3_mmr
        FROM sales_car
        GROUP BY make
        ORDER BY top_3_mmr ASC
        LIMIT 3 
)
SELECT * FROM top_3;

# MELIHAT MEREK MOBIL TERMAHAL TOP 3 BEDASARKAN HARGA JUALNYA/DEAL
with top_3 AS (
		SELECT make, MAX(sellingprice)  as top_3_price
        FROM sales_car
        GROUP BY make
        ORDER BY top_3_price DESC
        LIMIT 3 
)
SELECT * FROM top_3;

# MELIHAT MEREK MOBIL TERMURAH TOP 3 BEDASARKAN HARGA JUALNYA/DEAL
with top_3 AS (
		SELECT make, MAX(sellingprice)  as top_3_price
        FROM sales_car
        GROUP BY make
        ORDER BY top_3_price ASC
        LIMIT 3 
)
SELECT * FROM top_3;

# TAHUN MOBIL YG PALING BANYAK TERJUAL UNITNYA
with tahun_mobil AS (
	SELECT `year` as keluaran_tahun , COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY keluaran_tahun
    ORDER BY jumlah_unit_terjual DESC
    
)
SELECT * FROM tahun_mobil;

# TAHUN MOBIL YG PALING SEDIKIT TERJUAL UNITNYA
with tahun_mobil AS (
	SELECT `year` as keluaran_tahun , COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY keluaran_tahun
    ORDER BY jumlah_unit_terjual ASC
    
)
SELECT * FROM tahun_mobil;

# NAMA SELLER dan MEREK MOBIL YG PALING BANYAK TERJUAL UNITNYA
with top_10_sales AS (
	SELECT make,seller, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY make,seller
    ORDER BY jumlah_unit_terjual DESC
    LIMIT 10
)
SELECT * FROM top_10_sales;

# NAMA SELLER dan MEREK MOBIL YG PALING SEDIKIT TERJUAL UNITNYA
with top_10_sales AS (
	SELECT make,seller, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY make,seller
    ORDER BY jumlah_unit_terjual ASC
    LIMIT 10
)
SELECT * FROM top_10_sales;

# MOBIL YANG PALING BANYAK TERJUAL BEDASARKAN MEREK DAN BODY
with body_car AS (
		SELECT make,body, COUNT(*) as jumlah_unit_terjual
        FROM sales_car
		GROUP BY make,body
		ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM body_car;

# MOBIL YANG PALING SEDIKIT TERJUAL BEDASARKAN MEREK DAN BODY
with body_car AS (
		SELECT make,body, COUNT(*) as jumlah_unit_terjual
        FROM sales_car
		GROUP BY make,body
		ORDER BY jumlah_unit_terjual ASC
)
SELECT * FROM body_car;

# MOBIL YANG PALING BANYAK TERJUAL BEDASARKAN MEREK DAN COLOR
with color_car AS (
		SELECT make,color, COUNT(*) as jumlah_unit_terjual
        FROM sales_car
		GROUP BY make,color
		ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM color_car;

# MOBIL YANG PALING SEDIKIT TERJUAL BEDASARKAN MEREK DAN COLOR
with color_car AS (
		SELECT make,color, COUNT(*) as jumlah_unit_terjual
        FROM sales_car
		GROUP BY make,color
		ORDER BY jumlah_unit_terjual ASC
)
SELECT * FROM color_car;

# MOBIL MEREK KIA MODEL APA YANG PALING BANYAK TERJUAL UNITNYA
with kia_model AS (
		SELECT make,model, COUNT(*) as jumlah_unit_terjual
        FROM sales_car
        WHERE make = "KIA"
        GROUP BY make, model
        ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM kia_model;

#OMZET SELLER YANG PALING TINGGI DALAM 2 TAHUN
with seller_omzet as (
		SELECT seller, COUNT(*) as jumlah_unit_terjual, SUM(sellingprice) as omzet_2tahun
        FROM sales_car
        GROUP BY seller
        ORDER BY omzet_2tahun DESC
)
SELECT * FROM seller_omzet;

#OMZET SELLER YANG PALING RENDAH DALAM 2 TAHUN
with seller_omzet as (
		SELECT seller, COUNT(*) as jumlah_unit_terjual, SUM(sellingprice) as omzet_2tahun
        FROM sales_car
        GROUP BY seller
        ORDER BY omzet_2tahun ASC
)
SELECT * FROM seller_omzet;

# TANGGAL YANG PALING BANYAK TERJUAL UNITNYA
with tanggal AS (
	SELECT saledate , COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY saledate
    ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM tanggal;

# TANGGAL YANG PALING BANYAK TERJUAL UNITNYA
with tanggal AS (
	SELECT saledate , COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY saledate
    ORDER BY jumlah_unit_terjual ASC
)
SELECT * FROM tanggal;

# JUMLAH UNIT TERJUAL BEDASARKAN TAHUN
with tanggal AS (
	SELECT YEAR (saledate) as sale_year, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY sale_year
    ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM tanggal;

# JUMLAH UNIT TERJUAL BEDASARKAN TAHUN DAN BULAN
with tanggal AS (
	SELECT  YEAR (saledate) as tahun,MONTH (saledate) as bulan, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY tahun, bulan
    ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM tanggal;

# PENJULAN SELLER TERBANYAK BEDASARKAN BULAN DAN TAHUN
with tanggal AS (
	SELECT  YEAR (saledate) as tahun,MONTH (saledate) as bulan, seller, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY tahun, bulan,seller
    ORDER BY jumlah_unit_terjual DESC
)
SELECT * FROM tanggal;

# PENJULAN SELLER PALING RENDAH BEDASARKAN BULAN DAN TAHUN
with tanggal AS (
	SELECT  YEAR (saledate) as tahun,MONTH (saledate) as bulan, seller, COUNT(*) as jumlah_unit_terjual
    FROM sales_car
    GROUP BY tahun, bulan,seller
    ORDER BY jumlah_unit_terjual ASC
)
SELECT * FROM tanggal;


        