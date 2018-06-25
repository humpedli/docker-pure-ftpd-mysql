CREATE TABLE `ftpd` (
  `User` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `status` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `Password` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `Uid` varchar(11) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ftpuser',
  `Gid` varchar(11) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ftpgroup',
  `Dir` varchar(250) COLLATE utf8_unicode_ci NOT NULL DEFAULT '/ftpdata',
  `ULBandwidth` smallint(5) NOT NULL DEFAULT '0',
  `DLBandwidth` smallint(5) NOT NULL DEFAULT '0',
  `comment` tinytext COLLATE utf8_unicode_ci NOT NULL,
  `ipaccess` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '*',
  `QuotaSize` int(10) NOT NULL DEFAULT '0',
  `QuotaFiles` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `ftpd`
  ADD PRIMARY KEY (`User`),
  ADD UNIQUE KEY `User` (`User`);