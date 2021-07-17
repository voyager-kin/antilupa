-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 17 Jul 2021 pada 10.39
-- Versi server: 10.4.20-MariaDB
-- Versi PHP: 8.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `antilupa`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`cpses_mad9qhqvhl`@`localhost` PROCEDURE `sp_createUser` (IN `p_name` VARCHAR(20), IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(20))  BEGIN
    if ( select exists (select 1 from user where username = p_username) ) THEN
     
        select 'Username Exists !!';
     
    ELSE
     
        insert into user
        (
            name,
            username,
            password
        )
        values
        (
            p_name,
            p_username,
            p_password
        );
     
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `hoax_rating`
--

CREATE TABLE `hoax_rating` (
  `id` int(5) NOT NULL,
  `track_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `rating_id` int(2) NOT NULL,
  `score` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `hoax_rating`
--

INSERT INTO `hoax_rating` (`id`, `track_id`, `user_id`, `rating_id`, `score`) VALUES
(1, 1, 2, 1, 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `person`
--

CREATE TABLE `person` (
  `id` int(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `photo` varchar(20) DEFAULT NULL,
  `added_date` date NOT NULL,
  `user_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `person`
--

INSERT INTO `person` (`id`, `name`, `photo`, `added_date`, `user_id`) VALUES
(1, 'John Lennon', NULL, '2021-07-16', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `person_role`
--

CREATE TABLE `person_role` (
  `id` int(5) NOT NULL,
  `person_id` int(5) NOT NULL,
  `role` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `user_id` int(5) NOT NULL,
  `hoax_score` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `person_role`
--

INSERT INTO `person_role` (`id`, `person_id`, `role`, `description`, `start_date`, `end_date`, `user_id`, `hoax_score`) VALUES
(1, 1, 'Musisi', 'Gitaris, vokalis, dan composer band The Beatles', '1961-06-01', '1981-06-01', 2, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `rating`
--

CREATE TABLE `rating` (
  `id` int(5) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `score` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `rating`
--

INSERT INTO `rating` (`id`, `name`, `description`, `score`) VALUES
(1, 'pasti bukan hoax', '', 5),
(2, 'lumayan bisa dipercaya', '', 4),
(3, 'mencurigakan', '', 3),
(4, 'kemungkinan besar hoax', '', 2),
(5, 'pasti hoax', '', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `reaction`
--

CREATE TABLE `reaction` (
  `id` int(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `reaction`
--

INSERT INTO `reaction` (`id`, `name`, `description`) VALUES
(1, 'happy', ''),
(2, 'sad', ''),
(3, 'angry', ''),
(4, 'anticipating', ''),
(5, 'fear', ''),
(6, 'disgust', ''),
(7, 'surprise', '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `track_reaction`
--

CREATE TABLE `track_reaction` (
  `id` int(5) NOT NULL,
  `track_id` int(5) NOT NULL,
  `reaction_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `track_reaction`
--

INSERT INTO `track_reaction` (`id`, `track_id`, `reaction_id`, `user_id`) VALUES
(1, 1, 1, 2),
(2, 1, 7, 2),
(3, 1, 1, 2),
(4, 1, 1, 2),
(5, 2, 2, 2);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `track_reaction_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `track_reaction_view` (
`reaction` mediumtext
,`track_id` int(5)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `track_record`
--

CREATE TABLE `track_record` (
  `id` int(5) NOT NULL,
  `person_id` int(5) NOT NULL,
  `title` varchar(100) NOT NULL,
  `record` varchar(2000) NOT NULL,
  `date` date DEFAULT NULL,
  `url` varchar(200) NOT NULL,
  `user_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `track_record`
--

INSERT INTO `track_record` (`id`, `person_id`, `title`, `record`, `date`, `url`, `user_id`) VALUES
(1, 1, 'John Lennon and the Beatles Sent their record to space', '', '2071-07-06', 'https://voyager.co.id/', 2),
(2, 1, 'John Lennon being murdered', '', '1980-07-08', 'https://en.wikipedia.org/wiki/Murder_of_John_Lennon', 2);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `track_record_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `track_record_view` (
`id` int(5)
,`person_id` int(5)
,`title` varchar(100)
,`record` varchar(2000)
,`url` varchar(200)
,`date` date
,`reaction` mediumtext
,`truth_score` decimal(21,8)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id` int(5) NOT NULL,
  `username` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email_address` varchar(100) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `register_date` date NOT NULL,
  `status` int(2) DEFAULT NULL,
  `verified` int(11) DEFAULT NULL,
  `password_hash` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id`, `username`, `name`, `email_address`, `phone`, `register_date`, `status`, `verified`, `password_hash`) VALUES
(2, 'angkin', 'angkin', 'angkin@mantap.com', NULL, '2021-07-16', NULL, NULL, '$2b$12$PeipgqRHBUweOkZh1GGtbuAghn2zuaLCeuPPgcGMJ.3M3nWXL//VK');

-- --------------------------------------------------------

--
-- Struktur untuk view `track_reaction_view`
--
DROP TABLE IF EXISTS `track_reaction_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `track_reaction_view`  AS SELECT concat('[',group_concat(json_object('id',`tbl`.`reaction_id`,'reaction',`tbl`.`reaction`,'amount',`tbl`.`amount`,'track_id',`tbl`.`track_id`) separator ','),']') AS `reaction`, `tbl`.`track_id` AS `track_id` FROM (select `re`.`id` AS `reaction_id`,`re`.`name` AS `reaction`,`tre`.`track_id` AS `track_id`,count(`tre`.`track_id`) AS `amount` from (`track_reaction` `tre` join `reaction` `re` on(`re`.`id` = `tre`.`reaction_id`)) group by `tre`.`track_id`,`re`.`name`) AS `tbl` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `track_record_view`
--
DROP TABLE IF EXISTS `track_record_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `track_record_view`  AS SELECT `tr`.`id` AS `id`, `tr`.`person_id` AS `person_id`, `tr`.`title` AS `title`, `tr`.`record` AS `record`, `tr`.`url` AS `url`, `tr`.`date` AS `date`, `tblreact`.`reaction` AS `reaction`, `th`.`hoax_score` AS `truth_score` FROM ((`track_record` `tr` left join (select concat('[',group_concat(json_object('id',`tbl`.`reaction_id`,'reaction',`tbl`.`reaction`,'amount',`tbl`.`amount`,'track_id',`tbl`.`track_id`) separator ','),']') AS `reaction`,`tbl`.`track_id` AS `track_id` from (select `re`.`id` AS `reaction_id`,`re`.`name` AS `reaction`,`tre`.`track_id` AS `track_id`,count(`tre`.`track_id`) AS `amount` from (`track_reaction` `tre` join `reaction` `re` on(`re`.`id` = `tre`.`reaction_id`)) group by `tre`.`track_id`,`re`.`name`) `tbl` group by `tbl`.`track_id`) `tblreact` on(`tr`.`id` = `tblreact`.`track_id`)) left join (select avg(`hoax_rating`.`score`) * 100 / (count(`hoax_rating`.`score`) * 5) AS `hoax_score`,`hoax_rating`.`track_id` AS `track_id` from `hoax_rating` group by `hoax_rating`.`track_id`) `th` on(`tr`.`id` = `th`.`track_id`)) ORDER BY `tr`.`date` ASC ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `hoax_rating`
--
ALTER TABLE `hoax_rating`
  ADD PRIMARY KEY (`id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `rating_id` (`rating_id`),
  ADD KEY `score` (`score`);

--
-- Indeks untuk tabel `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `person_role`
--
ALTER TABLE `person_role`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `score` (`score`);

--
-- Indeks untuk tabel `reaction`
--
ALTER TABLE `reaction`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `track_reaction`
--
ALTER TABLE `track_reaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `reaction_id` (`reaction_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `track_record`
--
ALTER TABLE `track_record`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email_address`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `hoax_rating`
--
ALTER TABLE `hoax_rating`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `person`
--
ALTER TABLE `person`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `person_role`
--
ALTER TABLE `person_role`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `reaction`
--
ALTER TABLE `reaction`
  MODIFY `id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `track_reaction`
--
ALTER TABLE `track_reaction`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `track_record`
--
ALTER TABLE `track_record`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `hoax_rating`
--
ALTER TABLE `hoax_rating`
  ADD CONSTRAINT `hoax_rating_ibfk_1` FOREIGN KEY (`rating_id`) REFERENCES `rating` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hoax_rating_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hoax_rating_ibfk_3` FOREIGN KEY (`track_id`) REFERENCES `track_record` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hoax_rating_ibfk_4` FOREIGN KEY (`score`) REFERENCES `rating` (`score`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `person`
--
ALTER TABLE `person`
  ADD CONSTRAINT `person_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `person_role`
--
ALTER TABLE `person_role`
  ADD CONSTRAINT `person_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `person_role_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `track_reaction`
--
ALTER TABLE `track_reaction`
  ADD CONSTRAINT `track_reaction_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `track_reaction_ibfk_2` FOREIGN KEY (`reaction_id`) REFERENCES `reaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `track_reaction_ibfk_3` FOREIGN KEY (`track_id`) REFERENCES `track_record` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `track_record`
--
ALTER TABLE `track_record`
  ADD CONSTRAINT `track_record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `track_record_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
