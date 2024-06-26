# UAS-BDL-DIVAPATAR-YUDHISTIRA-PASARIBU-2201010047
1. Deskripsi Tabel:
-Customers: Tabel ini berisi informasi tentang pelanggan yang menyewa mobil.
Atribut utama: CustomerID (Primary Key)
Atribut lainnya: Name, Address, PhoneNumber, Email

-Cars: Tabel ini berisi informasi tentang mobil yang tersedia untuk disewa.
Atribut utama: CarID (Primary Key)
Atribut lainnya: Brand, Model, Year, RentalPrice

-Rentals: Tabel ini merekam transaksi sewa mobil antara pelanggan dan mobil yang disewa.
Atribut utama: RentalID (Primary Key)
Kunci asing: CustomerID mengacu ke Customers.CustomerID, CarID mengacu ke Cars.CarID
Atribut lainnya: RentalDate, ReturnDate, TotalPrice

2. Deskripsi Kode:
a. Tabel Customer:
-CREATE TABLE Customers: Ini adalah perintah untuk membuat tabel baru bernama Customers.
-CustomerID INT AUTO_INCREMENT PRIMARY KEY: Kolom ini merupakan primary key (kunci utama) tabel Customers, yang secara otomatis bertambah nilainya (AUTO_INCREMENT) dan bertipe data INT (bilangan bulat).
-Name VARCHAR(100): Kolom untuk menyimpan nama pelanggan dengan panjang maksimum 100 karakter.
-Address VARCHAR(255): Kolom untuk menyimpan alamat pelanggan dengan panjang maksimum 255 karakter.
-PhoneNumber VARCHAR(20): Kolom untuk menyimpan nomor telepon pelanggan dengan panjang maksimum 20 karakter.
-Email VARCHAR(100): Kolom untuk menyimpan alamat email pelanggan dengan panjang maksimum 100 karakter.

b. Tabel Cars:
-CREATE TABLE Cars: Perintah untuk membuat tabel baru bernama Cars.
CarID INT AUTO_INCREMENT PRIMARY KEY: Kolom ini adalah primary key (kunci utama) untuk tabel Cars, dengan nilai yang secara otomatis bertambah (AUTO_INCREMENT) dan bertipe data INT.
-Brand VARCHAR(50): Kolom untuk menyimpan merek mobil dengan panjang maksimum 50 karakter.
-Model VARCHAR(50): Kolom untuk menyimpan model mobil dengan panjang maksimum 50 karakter.
-Year INT: Kolom untuk menyimpan tahun produksi mobil, yang bertipe data INT.
-RentalPrice DECIMAL(10, 2): Kolom untuk menyimpan harga sewa mobil dengan tipe data DECIMAL(10, 2), yang berarti bilangan desimal dengan total 10 digit dan 2 digit di belakang koma.

c. Tabel Rentals:
-CREATE TABLE Rentals: Perintah untuk membuat tabel baru bernama Rentals.
-RentalID INT AUTO_INCREMENT PRIMARY KEY: Kolom ini adalah primary key (kunci utama) untuk tabel Rentals, dengan nilai yang secara otomatis bertambah (AUTO_INCREMENT) dan bertipe data INT.
-CustomerID INT: Kolom ini digunakan untuk menyimpan ID pelanggan yang melakukan peminjaman mobil.
-CarID INT: Kolom ini digunakan untuk menyimpan ID mobil yang dipinjam.
-RentalDate DATE: Kolom untuk menyimpan tanggal peminjaman mobil.
-ReturnDate DATE: Kolom untuk menyimpan tanggal pengembalian mobil.
-TotalPrice DECIMAL(10, 2): Kolom untuk menyimpan total biaya peminjaman mobil dengan tipe data DECIMAL(10, 2).

-FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID): Ini adalah konstrain foreign key yang menghubungkan kolom CustomerID dalam tabel Rentals dengan kolom CustomerID dalam tabel Customers, sehingga memastikan bahwa nilai yang ada di Rentals.CustomerID harus ada di Customers.CustomerID.

-FOREIGN KEY (CarID) REFERENCES Cars(CarID): Konstrain foreign key yang menghubungkan kolom CarID dalam tabel Rentals dengan kolom CarID dalam tabel Cars, memastikan bahwa nilai yang ada di Rentals.CarID harus ada di Cars.CarID.


-Indeks idx_rental_date ditambahkan pada kolom RentalDate di tabel Rentals untuk meningkatkan performa pencarian berdasarkan tanggal sewa.

-Kode View
CREATE VIEW RentalDetails AS //adalah perintah untuk membuat sebuah view baru yang disebut RentalDetails.
SELECT //Mendefinisikan kolom-kolom yang akan ditampilkan dalam view RentalDetails.
    Rentals.RentalID,
    Customers.Name AS CustomerName, //Kolom Name dari tabel Customers, yang di-alias sebagai CustomerName untuk menunjukkan nama pelanggan.
    Cars.Brand AS CarBrand, //Kolom Brand dari tabel Cars, di-alias sebagai CarBrand untuk menunjukkan merek mobil.
    Cars.Model AS CarModel,
    Rentals.RentalDate,
    Rentals.ReturnDate,
    Rentals.TotalPrice
FROM //Mendefinisikan bahwa data akan diambil dari tabel Rentals.
    Rentals
INNER JOIN Customers ON Rentals.CustomerID = Customers.CustomerID //Menggabungkan tabel Rentals dengan tabel Customers berdasarkan nilai CustomerID, yang berarti untuk setiap peminjaman (Rentals), informasi pelanggan (Customers) akan diambil berdasarkan ID pelanggan yang terkait.
INNER JOIN Cars ON Rentals.CarID = Cars.CarID; //Menggabungkan hasil join sebelumnya dengan tabel Cars berdasarkan nilai CarID, sehingga untuk setiap peminjaman (Rentals), informasi mobil (Cars) akan diambil berdasarkan ID mobil yang terkait.


-Kode Trigger:

CREATE TRIGGER before_insert_rental //Perintah untuk membuat sebuah trigger dengan nama before_insert_rental.
BEFORE INSERT ON Rentals //Trigger ini akan dipicu sebelum sebuah baris dimasukkan ke dalam tabel Rentals.
FOR EACH ROW //Menunjukkan bahwa trigger ini akan dieksekusi untuk setiap baris yang dimasukkan.

DECLARE //Digunakan untuk mendeklarasikan variabel lokal di dalam tubuh trigger.
rental_days INT; //Variabel rental_days bertipe data INT, yang akan digunakan untuk menyimpan jumlah hari peminjaman.
price_per_day DECIMAL(10, 2); //Variabel price_per_day bertipe data DECIMAL(10, 2), yang akan digunakan untuk menyimpan harga sewa per hari dari mobil yang dipinjam.

SET rental_days = DATEDIFF(NEW.ReturnDate, NEW.RentalDate); //Menghitung selisih hari antara tanggal ReturnDate dan RentalDate yang baru (NEW). Hasilnya disimpan dalam variabel rental_days.

SELECT RentalPrice INTO price_per_day //Mengambil nilai RentalPrice dari tabel Cars berdasarkan CarID yang baru (NEW) dari tabel Rentals. Nilai ini disimpan dalam variabel price_per_day.

SET NEW.TotalPrice = rental_days * price_per_day; //Menghitung total harga peminjaman (TotalPrice) dengan mengalikan rental_days (jumlah hari peminjaman) dengan price_per_day (harga sewa per hari). Hasil perhitungan ini akan disimpan ke dalam kolom TotalPrice pada baris yang baru (NEW) dalam tabel Rentals.
