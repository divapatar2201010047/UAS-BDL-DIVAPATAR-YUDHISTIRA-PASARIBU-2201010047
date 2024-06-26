-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 26, 2024 at 12:04 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 5.6.39

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rentalmobil`
--

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `CarID` int(11) NOT NULL,
  `Brand` varchar(50) DEFAULT NULL,
  `Model` varchar(50) DEFAULT NULL,
  `Year` int(11) DEFAULT NULL,
  `RentalPrice` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`CarID`, `Brand`, `Model`, `Year`, `RentalPrice`) VALUES
(1, 'Toyota', 'Avanza', 2020, '50.00'),
(2, 'Honda', 'Civic', 2020, '100.00'),
(3, 'Mazda', 'MX-5', 2020, '150.00'),
(4, 'Toyota', 'Supra', 2019, '200.00');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `Name`, `Address`, `PhoneNumber`, `Email`) VALUES
(1, 'Martin', 'Bali', '0895413466622', 'martin123@gmail.com'),
(2, 'Melisa', 'Bali', '0895413466622', 'melisa123@gmail.com'),
(3, 'Nisa', 'Bali', '0895413466622', 'nisa123@gmail.com'),
(4, 'Naura', 'Bali', '0895413466622', 'naura123@gmail.com');

-- --------------------------------------------------------

--
-- Stand-in structure for view `rentaldetails`
-- (See below for the actual view)
--
CREATE TABLE `rentaldetails` (
`RentalID` int(11)
,`CustomerName` varchar(100)
,`CarBrand` varchar(50)
,`CarModel` varchar(50)
,`RentalDate` date
,`ReturnDate` date
,`TotalPrice` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `rentals`
--

CREATE TABLE `rentals` (
  `RentalID` int(11) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `CarID` int(11) DEFAULT NULL,
  `RentalDate` date DEFAULT NULL,
  `ReturnDate` date DEFAULT NULL,
  `TotalPrice` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rentals`
--

INSERT INTO `rentals` (`RentalID`, `CustomerID`, `CarID`, `RentalDate`, `ReturnDate`, `TotalPrice`) VALUES
(1, 1, 1, '2023-06-01', '2023-06-03', '100.00'),
(2, 2, 2, '2023-06-01', '2023-06-03', '200.00'),
(3, 3, 3, '2023-06-01', '2023-06-03', '300.00'),
(4, 4, 4, '2023-06-01', '2023-06-03', '400.00'),
(5, 1, 1, '2024-06-26', '2024-06-29', '150.00'),
(6, 2, 2, '2024-06-26', '2024-06-27', '100.00'),
(7, 4, 4, '2024-06-26', '2024-06-30', '800.00');

--
-- Triggers `rentals`
--
DELIMITER $$
CREATE TRIGGER `before_insert_rental` BEFORE INSERT ON `rentals` FOR EACH ROW BEGIN
    DECLARE rental_days INT;
    DECLARE price_per_day DECIMAL(10, 2);

    SET rental_days = DATEDIFF(NEW.ReturnDate, NEW.RentalDate);
    SELECT RentalPrice INTO price_per_day FROM Cars WHERE CarID = NEW.CarID;
    SET NEW.TotalPrice = rental_days * price_per_day;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `rentaldetails`
--
DROP TABLE IF EXISTS `rentaldetails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `rentaldetails`  AS  select `rentals`.`RentalID` AS `RentalID`,`customers`.`Name` AS `CustomerName`,`cars`.`Brand` AS `CarBrand`,`cars`.`Model` AS `CarModel`,`rentals`.`RentalDate` AS `RentalDate`,`rentals`.`ReturnDate` AS `ReturnDate`,`rentals`.`TotalPrice` AS `TotalPrice` from ((`rentals` join `customers` on((`rentals`.`CustomerID` = `customers`.`CustomerID`))) join `cars` on((`rentals`.`CarID` = `cars`.`CarID`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`CarID`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`RentalID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `CarID` (`CarID`),
  ADD KEY `idx_rental_date` (`RentalDate`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `CarID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rentals`
--
ALTER TABLE `rentals`
  MODIFY `RentalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  ADD CONSTRAINT `rentals_ibfk_2` FOREIGN KEY (`CarID`) REFERENCES `cars` (`CarID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
