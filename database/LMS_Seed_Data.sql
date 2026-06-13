USE LMS_Library_Management_System;
GO

-- ==========================================================================
-- LMS SEED DATA SCRIPT
-- Total Users: 185 (5 Admin, 10 Manager, 20 Librarian, 50 Lecturer, 100 Student)
-- RÀNG BUỘC BẢO MẬT: Mật khẩu được mã hóa BCrypt tương ứng với chính Email đăng nhập
-- ==========================================================================

-- ------------------------------------------------------------
-- 1. GENERATING 5 ADMINS
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (1, 'admin1@lms.com', '$2a$10$r.vyJ.Dm7QEMPm5.zS0j7.XB/pV8idCVP.C6v11JPcJeuXvNyhtCa', 'active', 'admin', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (2, 'admin2@lms.com', '$2a$10$zElqI3ulQ/K2fMSJwDzaZ.xjonkjR.R5DlCIzfItaWpUj0Ds5wWG2', 'active', 'admin', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (3, 'admin3@lms.com', '$2a$10$fqlZ0T0PRjSTjIvcjHQRhuFIaBw..NGCgN26DDZR6E7eqKraLZa3a', 'active', 'admin', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (4, 'admin4@lms.com', '$2a$10$H8CgrGvUX5zXCP7Mz.xXfeWvp30weQ18kMdhBwhGfbb9zlLh3cw9S', 'active', 'admin', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (5, 'admin5@lms.com', '$2a$10$.TTn3fMRp8seS3FHTsZoJOzXmBOy5CLfJIFWVyiWF0/nvv/q9l11e', 'active', 'admin', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

-- ------------------------------------------------------------
-- 2. GENERATING 10 LIBRARY MANAGERS
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (6, 'manager1@lms.com', '$2a$10$iW8eys7464v91VDYsrWmuOl5lfo7VtUeD2K90JeCfPgoCV7EapAWy', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (7, 'manager2@lms.com', '$2a$10$WxvHPK.ij5KnJX/s/UrYZO7efxglmwxYOiliiymWQmMKbBppXHYGm', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (8, 'manager3@lms.com', '$2a$10$sJz5AZiEGWhTfsQKHIVSSeGR3AgskOEjKwKspMwErrlc1FTOgCJbO', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (9, 'manager4@lms.com', '$2a$10$GK7vHb8aJc39wzebmHnNMuWl7Zw9KonsAps57CDIa6tg3okqFm.iy', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (10, 'manager5@lms.com', '$2a$10$Xk3ykC1vpdqI2I5LwWGqo.mJEZUDYtYzfCYPHP8eFcWTC2KCWeFvm', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (11, 'manager6@lms.com', '$2a$10$KeCnbyQnwdcLTLWkeS94G.P5B6VQSZbWZ5bSj8Trgy.hM6s8sAE/S', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (12, 'manager7@lms.com', '$2a$10$pDYbiUeHtzOJPQ/tlolrwexQHvhrGvqus2LnH4VLXj1nDe8I9dIMy', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (13, 'manager8@lms.com', '$2a$10$eWjvCowMcq4Z8x5vms7TG.Q.o6DENc7DhcRbzfXkh2g.s3rUZedH2', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (14, 'manager9@lms.com', '$2a$10$2P4tFhO/sebN2CsZOVovpOp/zGdykbV0dIj3IH4AHb4Dr3TXMSPv.', 'active', 'manager', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (15, 'manager10@lms.com', '$2a$10$TvcMY4uVCsJRCbACDGOace.hokokAITWHzEY9bVph9JJRTyHGVZHO', 'active', 'manager', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

-- ------------------------------------------------------------
-- 3. GENERATING 20 LIBRARIANS
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (16, 'librarian1@lms.com', '$2a$10$e5VIXKASSjVCIqEfocYxhugugKlSUa7puWROvsBiL7xqdV8ZNjc3.', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (17, 'librarian2@lms.com', '$2a$10$s9onP4lOQd/jhpumK1zK6OgGRbUBRB31aiMWMm..SRDEw2DOUqUVi', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (18, 'librarian3@lms.com', '$2a$10$61B02W4lODyibV2J62YTS.Oc8BTbFQq5f5W.nTUQ7PUj1ArNL8hve', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (19, 'librarian4@lms.com', '$2a$10$EAcjxfKP2OYvJMbBlD1hhe11y0CWnju8NsUDHfJvNFO7aeJu/8Mn6', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (20, 'librarian5@lms.com', '$2a$10$PUC8o8zWgonSb8S2kqo2keSSekTSX18jFtdYO9BRZtTt6Wnfp3HO2', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (21, 'librarian6@lms.com', '$2a$10$m0qPogdmr0BEygLlHooGYeucQYdNAIHNLGqdegrQdnCblCrk2Bf7i', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (22, 'librarian7@lms.com', '$2a$10$VQDe1iHA84ww24rPF1SXYOmNUXx6boQ2EhA1Xek7dhudcZ3OT4VGK', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (23, 'librarian8@lms.com', '$2a$10$bHZnQ45iCxAFLsQwmr5Ql.uj6PSXc8hTkVtanNlhhdaiZ2LTHzQmO', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (24, 'librarian9@lms.com', '$2a$10$3HPSuOJSpGA6eilqF4aC8uWjy.T9IFTNFbqmVCl35rp52GTMfFveq', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (25, 'librarian10@lms.com', '$2a$10$uXgAhSFHkbuSFtrb1C/4GuyOHbGygIwykh/y7y6hojTX3zzOeTtFK', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (26, 'librarian11@lms.com', '$2a$10$SdkoYXJKCQosqo2dhfcdROGsxkKPlJeJ1aloAFHSWMzYeP0pysP62', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (27, 'librarian12@lms.com', '$2a$10$uzmrN6GsJPhQeaNsNbUlgOmfHMn6.EmY8JQwcZvBXSuhJvKNBQ9He', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (28, 'librarian13@lms.com', '$2a$10$1XfAOQsHZcZjalj1wMhaeuEAAPABQeftEKDc/HfqfbsfnykIWWBim', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (29, 'librarian14@lms.com', '$2a$10$ufVIUi/QzgQShrldfyBAEeb6H6qyk9854nJlUywvDkZafqzjALZ4.', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (30, 'librarian15@lms.com', '$2a$10$Ty8.50eY/SIPrS82TWhJSe6Ih8ISD3k5q2fXkmURu/24Q5UXiaQYm', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (31, 'librarian16@lms.com', '$2a$10$tUl6evWlwqPj.3qFWGkWlOTwPHtOq8wATr86/UaAeY9o/5TqLzho2', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (32, 'librarian17@lms.com', '$2a$10$0lPfRvWEFUJRf.LlxCB45ehKSs6ClGgn72RRjIZtiMdEGZfTkWmJu', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (33, 'librarian18@lms.com', '$2a$10$kXMG211poqZ00UEL9QF.VuvfSbmDmKyJmaztaqnIPDpirPBYp0pEq', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (34, 'librarian19@lms.com', '$2a$10$iaq9GwV.LEA.4msSgiCKIOPRO.VO/qH0suAQLZMen0OSByke9uQ7O', 'active', 'librarian', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (35, 'librarian20@lms.com', '$2a$10$LtWrysGbUU/4Sc9qq.rKieo5Zmi/2KaXcqFOVrMPxMIzx.wV1OjAm', 'active', 'librarian', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

-- ------------------------------------------------------------
-- 4. GENERATING 50 LECTURERS
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (36, 'lecturer1@lms.com', '$2a$10$EHYmhuknHOz50SUzD0cbD.dK.WJFz1vQK.qPLwUT.y8m1S.8AyOG.', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (37, 'lecturer2@lms.com', '$2a$10$qhglZko1JyKNa7BYjvvWNuOG/x1G0TBy2J8.nBCVywIGdc//QAK.C', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (38, 'lecturer3@lms.com', '$2a$10$Y.S9HrIkYolGw7pskqx/4.SvttdMDkYdYYq1sF.j9PiQuDepojdXy', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (39, 'lecturer4@lms.com', '$2a$10$ter8PsZSXeJUW70JaduyfuFJq16W/vkuFfsL1MtLZ1zMssXG7.gcG', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (40, 'lecturer5@lms.com', '$2a$10$MS9USaE.Rv4Cy0HBHlci5OtB1GX/ynMLqLJS12RjhpktiloPOxE4C', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (41, 'lecturer6@lms.com', '$2a$10$oGl/oyTu5Iu9ivczCco.Yu.s8weNoZ4zUhWVs9x173bzIuHFETTQK', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (42, 'lecturer7@lms.com', '$2a$10$kyI8NnFR0YDbdg7MOtsiDenpsSRKcywrt0IVttYoMH4d74jE4jN5S', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (43, 'lecturer8@lms.com', '$2a$10$axW7YK7Msafxs9PxeC3Wv.1c4jogUX.eLelQasBJj0HVhPc8HLzia', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (44, 'lecturer9@lms.com', '$2a$10$wQKPEnMg9Knua.ApurBET.5k0AEsLVxykTM3uG8oUJ/dU3QAevcna', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (45, 'lecturer10@lms.com', '$2a$10$fBPKdPUgVISToqc3ZpE1NehIMKP5wFTesDdiNzV.yvFhHE80E2dgS', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (46, 'lecturer11@lms.com', '$2a$10$eTE6YKBrHM/u9m/HCTrcOOkbsuhJ18IM3umeTx9Qq0.5clW1rNo.u', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (47, 'lecturer12@lms.com', '$2a$10$ggLCnfcZwyNkdeKbI722Ve0SYRJoxFU0EKPGJQ9Fjf1t1J9sGQMnq', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (48, 'lecturer13@lms.com', '$2a$10$DZZ2mhqW5BbszQ.nzm6KeONioUaBmszgplEyt3ad/BEYF8oQUJ0xu', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (49, 'lecturer14@lms.com', '$2a$10$1msdm6csD7Fp1/6WzC4oL.k2RIiTLMrbidFucIhBGSxnFDHGoi9ny', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (50, 'lecturer15@lms.com', '$2a$10$p2EwtHbBpiZAHCln61Wrxu0q6A5JNYXyERqHDVs3AUlDpkPtX.28e', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (51, 'lecturer16@lms.com', '$2a$10$eqZMgKYjM/mU.so8JM4ee.cGTBDADVALAsrzhoIjcTA8vHZWUdfY6', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (52, 'lecturer17@lms.com', '$2a$10$061OyiE7XSI7ZsY2HVxIXeG6NXnFbF6biufP8zjUrupvNrCLdtPX6', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (53, 'lecturer18@lms.com', '$2a$10$l5JjCDKLwYoKjXU1dEVWoOsCHhG3fiTNHwN.IUfEsduGFAJ/W/RKi', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (54, 'lecturer19@lms.com', '$2a$10$pC/lbsmaOpU31tSAFraZWu30feFKPJ28K/CgDxJqOaY4SNFFP.1ba', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (55, 'lecturer20@lms.com', '$2a$10$0B6pqF2VerYoHj6lfzG80.URvPg2EHcwaPocc9dYNjMo.i2Qr.Aja', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (56, 'lecturer21@lms.com', '$2a$10$9dOoo22ZQbZryPN7NDgzleusiYbRMQun4vKml8KIM6OJnHFLRIJKm', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (57, 'lecturer22@lms.com', '$2a$10$ta5vm5eTumvIQH9v3K0Nge6MQyPuy4byBGV8nfXo5v/COVQ1WYX1u', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (58, 'lecturer23@lms.com', '$2a$10$Zvy.1Y1sv6J5qXUzh7GAz.Fse4g5j59Qyrp4ZMli4X6dgRuSa41rm', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (59, 'lecturer24@lms.com', '$2a$10$gWezYGTqvCMcKMh0Ol0zhuV0FqKR5j4RJMR7kxK9j10d/mPik/euS', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (60, 'lecturer25@lms.com', '$2a$10$5V6S98DGEDFUI1VKTCl6aebUMIyovX9KUzjbXqi2dpJ4jJXpldOZ6', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (61, 'lecturer26@lms.com', '$2a$10$o28vixG9oGuihHdK8z15gO.p3IKcG0cDB4YkH/HRrCyKxQWyASihm', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (62, 'lecturer27@lms.com', '$2a$10$srdceSmCT/Hnt.LzWdlqfemgo9F9b.hJZXrSFDRUr4QmJHkN5kRDO', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (63, 'lecturer28@lms.com', '$2a$10$km3kKrzakyddOFHLVGcNd.wPbh8l4szoinGlzrH9oMZgGhRIlfnxK', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (64, 'lecturer29@lms.com', '$2a$10$1YRDxcXZSYoGEAKRr.FYOOCq02p1KGVP8M2gMofXcOv3O67/yX.ke', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (65, 'lecturer30@lms.com', '$2a$10$IffkVL5EZExo8quwmirsLuGq.dCrVO4zUV8hgvt/RQoWZkj1YRGvK', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (66, 'lecturer31@lms.com', '$2a$10$yDLXVbMLjNsP.xwtdnS3HuO2sFKTMf7JpswvaKdHJxGn7zY/OXBLC', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (67, 'lecturer32@lms.com', '$2a$10$XUVGDqRrYgR.52oi8h/8AOuROOSKOxNAjtF5ZQ8NHevKokSUHq9Nq', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (68, 'lecturer33@lms.com', '$2a$10$Iunb8DkjZJ/vPOXASF0vpesf4lMRxhE9lv.vyvhVVvizjw7Thn/FC', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (69, 'lecturer34@lms.com', '$2a$10$N0/kBq/UzFlPkGvLAMSdkeu4RE.K425Knyxa8NVbok42fdz2GgKuq', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (70, 'lecturer35@lms.com', '$2a$10$vIN1syr0ncBkoaCjyYB03.CyxybNfFrYU3gxT5nwl5cZfb93B.RNe', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (71, 'lecturer36@lms.com', '$2a$10$tl78nNfWCKdlYZIuPD8CPuHedhveyTHyh97Q2wMT5ZGO2eKE4AL5K', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (72, 'lecturer37@lms.com', '$2a$10$63FD2HmGyjEtGO.kqvB0cupxaz5TijwjMUtsUd7ZE9DDY4K3qjWrK', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (73, 'lecturer38@lms.com', '$2a$10$Fwvb1FjWIeKKsZ/Iv4URyOftia9GuHv.O7zxE60s6dJvi83S4ARKq', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (74, 'lecturer39@lms.com', '$2a$10$x4XD9VvXk/9aPmU56.SbeewEbb5Dniv98umV0skp802OfJCLVu..S', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (75, 'lecturer40@lms.com', '$2a$10$H7cIyHrfNy1N/AlVgtEKSuAKs/xt9u0ydqNeyxjqnS3F.5.8Ij08K', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (76, 'lecturer41@lms.com', '$2a$10$W42RBAxhwp80HWNw48X5p.bimRqyAXYG9zN05Jqa9HNZ.jFXEsAw6', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (77, 'lecturer42@lms.com', '$2a$10$EP/5KTs8uEjaHghL3jUyNOlninnfzEJE4405B.WNY7gDYGbzvwOhC', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (78, 'lecturer43@lms.com', '$2a$10$UkqcfOk3N.LrNay2i7.YbOMALcRIFFLsn4gDZ9CYImZ7OZZcIasMi', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (79, 'lecturer44@lms.com', '$2a$10$Fj9S6ZRh4JgqIY7nXOlcNe9wTLPYIK0sH1HAKlaz2mTqgQJyX/9X6', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (80, 'lecturer45@lms.com', '$2a$10$aQoIVPFK1GTfxbx13D2uDegl0IO9dqVESHNiGxPLva5CdAoA/ofPu', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (81, 'lecturer46@lms.com', '$2a$10$ttA0XWkLBcvN7Ua3snuGP.wUpS3y/Kz36lq.EIjXqFc5hbv6SpFc2', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (82, 'lecturer47@lms.com', '$2a$10$boNoQh6024qjaq9qr1aOQORThkUfJDvMEmvg/J3c0B/KHObVZcAWK', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (83, 'lecturer48@lms.com', '$2a$10$MIZGw.tV3SnzIJQTpNfrXeDQ1RCyE6mZnR/7tuAkbL7kRy02.74S2', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (84, 'lecturer49@lms.com', '$2a$10$Okl14uayJHNQsms48unue.ZgUG4V.sftJcvUTw6nNA71Jr35vmrau', 'active', 'lecturer', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (85, 'lecturer50@lms.com', '$2a$10$ADBTvE0vbuYjmhbDUHnpiui/H8Cm3NgglS4CpvfUhYlnksuiVaqgy', 'active', 'lecturer', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

-- ------------------------------------------------------------
-- 5. GENERATING 100 STUDENTS
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (86, 'student1@lms.com', '$2a$10$6dWSrkoI9NLFHj/mtVS3XOKS6GJ2ZL28Rb3rhSMqTl2Lble5X0XYi', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (87, 'student2@lms.com', '$2a$10$/2f7q7msgA80eqOaVtXeuuTHD2VOFYJseoTIFNEXKKui7JutAQENC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (88, 'student3@lms.com', '$2a$10$TYWKdG2ZlMxqJfbH.dIhfOF5.L5FlmI/6S6tmPSK0IAD/kRRiDSma', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (89, 'student4@lms.com', '$2a$10$D1HD7skcRqqVEb/6q36deeVsE9VqBoGae9zTZr0Nyv.UkwE9NHE3G', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (90, 'student5@lms.com', '$2a$10$QW5cejGN/YEfEPOWVaWOGO9oi9S8G44bfwyKJQOnJuqQHWRcYmt/q', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (91, 'student6@lms.com', '$2a$10$S4x7p2V/NNzfkw9GQDzrO.dtk9/ecmqVh.UIcLfhBndL.DQ1BVVY2', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (92, 'student7@lms.com', '$2a$10$JEbP/K3RIZQx1QXzI4MVGOny3rOpRUWZr9EDA885JAyVPjBvRjZUu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (93, 'student8@lms.com', '$2a$10$zV.2.Bf4a0FPZe7d8hr2UudZv4v6bsDsO.GdJGM.0b3/dc2P5u2hi', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (94, 'student9@lms.com', '$2a$10$z.OzuU3Md3B1mcOhjqvfMu1dKySPBVnrAUpf8IRlkhXEZ/aWvNNkW', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (95, 'student10@lms.com', '$2a$10$wGi0YfWU52OIiwov6GV35ubDUhKPaJtsGMKo2WHGNlYBZsZ.aj2pW', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (96, 'student11@lms.com', '$2a$10$Jz4HKwLoVkmb/stlGqtF8O3bnUU5C8Hh9HEUgGT5DQxCeAXV.hWLC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (97, 'student12@lms.com', '$2a$10$QaSCAszLLK3bF0jQGLF1HeSMBprsWXEgI9dQEMwYwQackTo3sonya', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (98, 'student13@lms.com', '$2a$10$jo7Q8HdGnQfqhZNxunJ5O.YjJY7Rq1kV5FGulD6rhtkIoZMXMFLi2', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (99, 'student14@lms.com', '$2a$10$5dZYsIYsP2ppT66SjuYN3eCFT67d0hfv9.lDsQLZJWUA/BSj3wU8K', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (100, 'student15@lms.com', '$2a$10$mteOnfcYD2vtHiBovIguhOiVartxcqAKWWAD6lqIBQ5T1fStXK1tu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (101, 'student16@lms.com', '$2a$10$jH.wdfRADmVg5PVvadHtKunIUSG5qBY3QNtDBfV8V0vApwFrFU1Cu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (102, 'student17@lms.com', '$2a$10$EIWRh0qAzaqEhA.6VIBF4OF/L1ZLcW9GFqXNicxemN01Wacxdk37m', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (103, 'student18@lms.com', '$2a$10$sr3IP9fcrbktkWwAHd.aT.8rnX.cXVyY17E6QK5YpcLRYdEmwHZ.q', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (104, 'student19@lms.com', '$2a$10$OVCBurbZowYCfgd3UrzUgukjKi.G9bfUh1LYNJTIsp.KaO2tXPcBe', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (105, 'student20@lms.com', '$2a$10$yELycLT1.o8JwgflXxoByO2mY92JKgXZriuNtmv6YrH9m08BpxuQ2', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (106, 'student21@lms.com', '$2a$10$WIQ5PU1GUfU5sb3xDHqjtOqgkF4NqDMFlZkI8ofyWJfwycaHTZeAe', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (107, 'student22@lms.com', '$2a$10$LC.ZuZMopALNlPruWbllkO5TL9H2Bo1YU0SgaqCHsS1VyovWg8EWu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (108, 'student23@lms.com', '$2a$10$slFJclWFDazmRTA1/4nhs.3sUj7jfdxrxbeOjObGbedyJvxvwZ3gu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (109, 'student24@lms.com', '$2a$10$xSDasvizstqAAYxMWZAL7e4pCxixT6/zPYX8XK8/QqvAIEzatwhUG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (110, 'student25@lms.com', '$2a$10$Qn9G76DZkX6w3MiL7Awuoee.1llQsFysij6sYMZ6QRQOOJFTLWUN.', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (111, 'student26@lms.com', '$2a$10$mFrRBHKlDalzboo9K/DhSepxsO07Ymm6ql5xds684U48.qXg3JCM.', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (112, 'student27@lms.com', '$2a$10$kEKouqBMlKek5oUsSpREtO52NpbVM6HEZP2drmMC7f77IHsvifJ/W', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (113, 'student28@lms.com', '$2a$10$eVpDV1MLVx7M76K7sR7zWeNv77e25g3WVetbM5Xm5Cm1StOBUXYZq', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (114, 'student29@lms.com', '$2a$10$62GArN/FkJ9Y3Qa8GDjY.u.NkKZ92/2F1VHEE8AtwxruDWlIChvcm', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (115, 'student30@lms.com', '$2a$10$T0oZQmebiIKovO0jpLrZN.gltMe6R49jtNhKuHzn.RyGV5UdzCe4u', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (116, 'student31@lms.com', '$2a$10$8/yc12pS6OVdxbY3pfg0K.hrXOKOaCXjKd9Izt7yWVVVES0hMLkUG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (117, 'student32@lms.com', '$2a$10$jhWm0fmrxhFjd.OFwGuVB.vQbshAoqE/fxK2IVhTGt/tMiHggXHaC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (118, 'student33@lms.com', '$2a$10$qdNhjbgroA3/rXbh/BbB3ejvahGbQL8jaWHlKwfUy/rfoeYuC22Mu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (119, 'student34@lms.com', '$2a$10$iXq/li2y8A.dOYERTHjZte.HtCH6akvx0M5DVw2V4dO0A.unQRT.y', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (120, 'student35@lms.com', '$2a$10$nlrBrqohBEbLpQxIPRnojORTbE1Gt9P0rVJHIlJYoqYvulKgJMU1e', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (121, 'student36@lms.com', '$2a$10$omNc/xm7Gs6wujK5ig5jJ.W3fQgESQRSb.SrMhqkaKm0j7946Qozm', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (122, 'student37@lms.com', '$2a$10$o7lMdYHHjdEWMbwkrGefneaGBkRyF6op.NuYjaiaTHV89ltw7rqoK', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (123, 'student38@lms.com', '$2a$10$tRL88AIIeqmj/AKCQPrEvOft5CuK1PhON2T1CvgHe7FYof4/tc16y', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (124, 'student39@lms.com', '$2a$10$6A1whf.UDw/TRODYP.lQTeu/hx3tawS/xBKvyZlVMs1a.qyHD94YG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (125, 'student40@lms.com', '$2a$10$ybnQevI2rbZRdAQUk8nhye/EmQPSt45VJrKoFfOKVybNzE0VABMc6', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (126, 'student41@lms.com', '$2a$10$BV6Y3GktzWsqTAp0t5WtyeoHXhYilSUkUr.t7i6.yAwi4CO.FgVuS', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (127, 'student42@lms.com', '$2a$10$ALUZurIW3Ip7qxaVvetqd.QbhlahGn9MCMkJl91HVdmJVOO7zJNJy', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (128, 'student43@lms.com', '$2a$10$AY9DpCjS1mxoFhKTpq9AUO1B7P556NXPycokL9CtBRCFxk/D.6i5q', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (129, 'student44@lms.com', '$2a$10$4D6envjyfSa/PKKauLR3u.PBBCqB.68u5Cc/POfvc6ThPJKi85lMC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (130, 'student45@lms.com', '$2a$10$5AIWz/BVifFKKFsJM2Cvx.ntIX4cEFzguINhpH1QKpxnbSQI3azpy', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (131, 'student46@lms.com', '$2a$10$hKhhcPjQUDogoONc/4eJmeTk3dXxbG.C5xFF2qWX//kvM6dIZlk52', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (132, 'student47@lms.com', '$2a$10$p0n73oESp3wk.vqBieoPBOwUr6HZOSUpGYGaEdXTEpb1wW2Czux96', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (133, 'student48@lms.com', '$2a$10$JUzcucdrxDM03G8G4kmk0OABjzJjcyUO0BhIhfKrfLgfuKhL4IdB6', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (134, 'student49@lms.com', '$2a$10$02POnsLD1VHl95q.c7oRRevsk9NzvpikfI/.phz505kJhWudyDG6S', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (135, 'student50@lms.com', '$2a$10$Fnahe2aec6jyiNQ1CCX8tus7MPkZROZ/QtYnvj/sGy6wHnc7XTHeW', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (136, 'student51@lms.com', '$2a$10$kj7CZgRU80n9vy7biJ76SOSg2sWKLzVc.lIyNeMoAHBEWC2WPc.Za', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (137, 'student52@lms.com', '$2a$10$iJIZ0u.qKtJdCGfwHYMWcu4OR5enT4u/zHzHtlhbfOP3bvP3sahBa', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (138, 'student53@lms.com', '$2a$10$9wXVBzYYHhp0pjK5tr9c/uegM8E/7wupBEsqkAQ0edvYjzpsxns.G', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (139, 'student54@lms.com', '$2a$10$c1iNUd85e6H5DERPAPN56.zeNyTTb.5c2yCH0q1DWxOitcx7CHjiK', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (140, 'student55@lms.com', '$2a$10$xF5m/XQVCEKj5EENY.utLuElAB9KhDeyOCth85aZoRgIbv4BSqqAm', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (141, 'student56@lms.com', '$2a$10$z6TM2LnegYy2b5F0unh63ONpyG1/x0ktwTcKAoQO9e3TYS9h/DrPO', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (142, 'student57@lms.com', '$2a$10$4fbNV4RNrhEs/TFpdR9QtehDEzn66SHZW1DpdOkaxwxFt1Eij6KTi', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (143, 'student58@lms.com', '$2a$10$YBuVyuiNN7sPiu6TsOXWD.CrisSA0n0nHY64asfvL5/OLGm4yxSoy', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (144, 'student59@lms.com', '$2a$10$0.dJqohIj5u4SjHl6yQYveV67K156GTlKBAKDrH.VzotnnbVl/0Jm', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (145, 'student60@lms.com', '$2a$10$89dGi0ZoPv.UTVXYpfR6AOSUnSvDvAoYRj4giiAys.oq.FMbUaKPO', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (146, 'student61@lms.com', '$2a$10$DQuCVKSkYXR.A6Pfo5bmguLCacoFEDJ8XbeGjsGIqrrqcbOEcDcj.', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (147, 'student62@lms.com', '$2a$10$hNyyc0Ipg31LtxGUxuqxZeCA3GTTQUBuOAZ3/M3Q38RbkTUx7hbtO', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (148, 'student63@lms.com', '$2a$10$JuUyqH.GVlFgR3JKY22Mc.u53mTMy0SXikcGhSteK1hcoJ.wjiXnK', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (149, 'student64@lms.com', '$2a$10$Rf1X7qC655y5CUSUQBhEMegsdBu7NN9hXkQCxvaTMLAW6GHD9ghLi', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (150, 'student65@lms.com', '$2a$10$LolbBMZOwwk7AJnfa7tfW.6oUF8o7wTvmFH4gagnhb0XaSlToT2PW', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (151, 'student66@lms.com', '$2a$10$X3IwDQJpRY4OW9w7IZB88OWVLp/CTZ87e7N/grMYgacUQyyQY69Ee', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (152, 'student67@lms.com', '$2a$10$dQSYWBG3zwSHN5zXMLV6/eVryzQUVUGJL35JcGHsvim6OQAtcE8CO', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (153, 'student68@lms.com', '$2a$10$voCdRB8F7iGQrpVerxRMMON6uEUQs7YtlC82p.e3B43wCgTftra.6', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (154, 'student69@lms.com', '$2a$10$6MyEM9yvoUvbnA1PbYfag.okrNYKoc3ALkbUXJfYbPYswY9HSdz3y', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (155, 'student70@lms.com', '$2a$10$utJ/k1kmuT/A9uD3uG2oNe3awXssRoUeN1etTi1/0IV/0kLvaFh5y', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (156, 'student71@lms.com', '$2a$10$vsaa9WSoSm7Mpytx2IXQXO23ZuAvPogwL1wP6o57wj8Ee1yBIY3qK', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (157, 'student72@lms.com', '$2a$10$9qOBuQFJcp6nhZKy0UZuSuQ80T1t1IgH2nTsOduzlxoZPzoHRjzPC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (158, 'student73@lms.com', '$2a$10$FTYHV1F5DFfftXKD4O0zcOW8SuA/y1.terdESCAQzskunItqHXGdi', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (159, 'student74@lms.com', '$2a$10$EODxEGUWwww2EqDLtfIvpuOP2ma.vd5izzTPGESPFyM8C/pxPFTka', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (160, 'student75@lms.com', '$2a$10$E/wX7kWMLN/YhahvNijDMOjhGOre.USv0kpcxV0pc4hHD4nFDwkCe', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (161, 'student76@lms.com', '$2a$10$ZeDxGhvG8N431NAzdqbtxu6PmhV7zDAV6O5auqnUt/q2otAZoTQRK', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (162, 'student77@lms.com', '$2a$10$Ig0YBHTZakKWntFACpgey./st90XUQWd.O0WAsJS7NqY/Gekzh5Ue', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (163, 'student78@lms.com', '$2a$10$w9Hch4hmNla/9DBOm2b.se9StleMFypuFVn.rzEceRqZLJ0F9xBbG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (164, 'student79@lms.com', '$2a$10$GxpT/S8F0sdSIxtDtr74auNvTm4JCxhpxu.f1L/3Tq9Ie7ISU8CGW', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (165, 'student80@lms.com', '$2a$10$62dI4eeeW9Dy/ZEH5lMjJeliHKaptpG09NMqXQzfbdPbDUYB/HVaS', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (166, 'student81@lms.com', '$2a$10$RKJrKf969VFg0iO16JxYNuTRMn/A9D6z/sHbCFKYj8OFjW6UVximu', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (167, 'student82@lms.com', '$2a$10$MYt/ePQmlYUrZ1sa.oT/KueRjfg25qe7RD1TvOCXko3fFZOgONOXa', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (168, 'student83@lms.com', '$2a$10$elIjwpID9Ye28rXd77liiu1/71X1kCoKTS.L8GHPRK16743/4rU5u', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (169, 'student84@lms.com', '$2a$10$B4PV.lwJSg2jd1auZn8DH.4RkkMfr5o3uFEOP3aTZbhD6b3Npr9ga', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (170, 'student85@lms.com', '$2a$10$ovHEXkA0lZD40xQaLyXmCurwXwG08JBFgkGAbnsPKxrKuq5ivJZSC', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (171, 'student86@lms.com', '$2a$10$bYFA7XMV0xoMZJWXCFndSuGFT2RnAT9XkZd9hc8o/VXb0Vm8lzr72', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (172, 'student87@lms.com', '$2a$10$kvAh7cYMFFwI6ZDA7nbuouWijXol0.8OTRGyWCXwEQbiS4G.mKFMm', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (173, 'student88@lms.com', '$2a$10$JLjNsWx8eEZPeRK.AM9RB.GV9XTbl74DNcm5Yn9KP/iHiIRfDNPsy', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (174, 'student89@lms.com', '$2a$10$8D7Ar4ph3KRgaDmk.IikbOhUzV3SEZYw5VbrKh922HjbaXW.87vNq', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (175, 'student90@lms.com', '$2a$10$ePgygXjGtRGvkOjVWeVtIeabxOR.hQX/FSpOuiEhACovWLwF1wRW.', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (176, 'student91@lms.com', '$2a$10$irdNnxkeyUIvX.ULfzNo7uwd59vdtih.d3tOoZqiOPxvk2UvBByPO', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (177, 'student92@lms.com', '$2a$10$J4p1iWOdd9.z19wOzUCnPOL2mXTfFT1V08R7MKlM7ilocIY12.1EG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (178, 'student93@lms.com', '$2a$10$Gb7WaeT0y5YrBjXt2dJj1OyHdeVyREOyF6bu7LG/s7oGFL9RXTisa', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (179, 'student94@lms.com', '$2a$10$PEVweK6yb5NtXEJKuezf5OD0Cpw4udqVizZulbJyMbgOMy7KVFjeG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (180, 'student95@lms.com', '$2a$10$rVRBPR.AsADPkKSeiZWoWewMBS7aukJvPbp/BdUgMXutLAGBTHqaG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (181, 'student96@lms.com', '$2a$10$HSz5HELJWiyAOZ78Y8JuQ.qv5LEufUufQk.sWeCViZ/0lz9.s18gG', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (182, 'student97@lms.com', '$2a$10$QlkNiylwS5faV7ihoOfFNeDoQCIAn6G0ugp.otO5CTYtZ6fA9Hm2e', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (183, 'student98@lms.com', '$2a$10$CEozwnU5wtr1OcBFvbyMi.7.uaSp77mfF4snXCBcu6zw8dpHD1j06', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (184, 'student99@lms.com', '$2a$10$5jah99pZ9O1tjf/cQ/o2NO/TFtMrWuSQhfiNEP6GNhoXYotwYTb2e', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (185, 'student100@lms.com', '$2a$10$EmwyAPAhGI1yDZ8cbFH8y.8zkPPYuFUnRF3.G6ktaaTYPjJS.YkrS', 'active', 'student', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

-- ------------------------------------------------------------
-- 6. MEMBER PROFILES
-- ------------------------------------------------------------
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (1, N'Pham The Thanh', '0962969970', 'Male', '1995-06-11', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (2, N'Dang Van Anh', '0991955276', 'Male', '1977-09-25', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (3, N'Nguyen My Huong', '0974241400', 'Female', '1978-03-10', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (4, N'Vu Quang Phong', '0980917387', 'Male', '1996-11-21', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (5, N'Phan Hong Nga', '0969835212', 'Female', '2003-02-21', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (6, N'Do Viet Giang', '0945593975', 'Male', '1984-08-24', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (7, N'Duong Phuong Nga', '0956205558', 'Female', '1971-09-15', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (8, N'Hoang Xuan Long', '0932025897', 'Male', '1989-09-10', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (9, N'Ly Quoc Hai', '0967183775', 'Male', '1989-11-02', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (10, N'Hoang Phuong Trinh', '0982080986', 'Female', '1970-06-22', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (11, N'Hoang Khanh Quynh', '0924337807', 'Female', '1973-10-05', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (12, N'Hoang Kim Mai', '0920829923', 'Female', '1995-12-20', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (13, N'Vu Minh Dat', '0904029870', 'Male', '1990-01-02', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (14, N'Tran Thanh Hung', '0927545275', 'Male', '1977-03-01', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (15, N'Tran Dinh Phong', '0923308806', 'Male', '1975-03-24', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (16, N'Pham Xuan Quan', '0921222652', 'Male', '1997-11-08', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (17, N'Vo The Son', '0956226238', 'Male', '1982-01-05', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (18, N'Le Viet Hieu', '0968001373', 'Male', '1987-02-28', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (19, N'Dang Thanh Nhung', '0906716447', 'Female', '1986-11-24', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (20, N'Nguyen Xuan Thai', '0987772600', 'Male', '1996-03-18', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (21, N'Vu Duy Huy', '0996018065', 'Male', '1975-03-22', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (22, N'Tran Van Nghia', '0931028741', 'Male', '1978-11-02', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (23, N'Vu Phuong My', '0976774046', 'Female', '1999-03-12', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (24, N'Phan Thi Ngoc', '0966918492', 'Female', '1996-03-18', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (25, N'Duong Thanh Quynh', '0958046189', 'Female', '1983-02-27', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (26, N'Dang Thanh Nhung', '0942401269', 'Female', '1997-07-04', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (27, N'Phan Thanh Vy', '0919900488', 'Female', '1973-11-22', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (28, N'Ho Van Giang', '0994821675', 'Male', '1986-08-08', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (29, N'Dang Quoc Viet', '0945345174', 'Male', '1982-10-02', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (30, N'Ngo Xuan Huy', '0958761587', 'Male', '1985-06-23', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (31, N'Vu Khanh Lan', '0954405088', 'Female', '1991-02-08', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (32, N'Do Quang Phong', '0948395881', 'Male', '1995-10-12', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (33, N'Bui The Dat', '0929601358', 'Male', '1979-01-13', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (34, N'Vo Huu Phuc', '0965180099', 'Male', '1971-03-25', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (35, N'Tran The Nghia', '0943878186', 'Male', '1996-04-11', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (36, N'Ly Viet Tung', '0967896410', 'Male', '1976-08-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (37, N'Phan Duc Thanh', '0918758619', 'Male', '1992-12-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (38, N'Do Hong Vy', '0978955047', 'Female', '1984-07-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (39, N'Bui Dinh Anh', '0932741866', 'Male', '1992-06-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (40, N'Ly Khanh Trinh', '0927653955', 'Female', '1993-10-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (41, N'Do Quoc Thai', '0908818688', 'Male', '1983-06-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (42, N'Ngo Xuan Giang', '0935584741', 'Male', '1997-09-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (43, N'Duong Dinh Thinh', '0952539109', 'Male', '1974-04-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (44, N'Dang Minh Tung', '0993465959', 'Male', '1993-01-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (45, N'Vu Thi Phuong', '0928152706', 'Female', '1982-08-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (46, N'Le Thi Phuong', '0938529856', 'Female', '1994-06-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (47, N'Phan Duy Trung', '0997866718', 'Male', '1986-09-07', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (48, N'Ly Thanh Duy', '0908001802', 'Male', '1977-01-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (49, N'Le Duy Dung', '0945876515', 'Male', '1986-09-19', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (50, N'Ly Quang Toan', '0911278717', 'Male', '1986-01-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (51, N'Vo My Linh', '0968013978', 'Female', '1983-05-06', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (52, N'Vo Quoc Anh', '0982996337', 'Male', '1998-05-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (53, N'Le Thanh Nghia', '0930286249', 'Male', '2003-06-12', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (54, N'Do Khanh Oanh', '0988039134', 'Female', '2003-03-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (55, N'Duong Thanh Phong', '0973212379', 'Male', '1991-09-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (56, N'Dang Xuan Phong', '0966940894', 'Male', '1988-09-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (57, N'Ngo Viet Hieu', '0976390360', 'Male', '1993-06-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (58, N'Tran Vy Anh', '0964282281', 'Female', '1972-04-20', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (59, N'Ngo Kim Yen', '0931754599', 'Female', '1986-09-06', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (60, N'Vu Ngoc Oanh', '0946915480', 'Female', '1995-10-07', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (61, N'Dang Dinh Long', '0973436530', 'Male', '2002-03-27', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (62, N'Tran Van Dung', '0901011234', 'Male', '1979-02-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (63, N'Bui Huu Minh', '0954044673', 'Male', '1996-08-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (64, N'Nguyen Anh Nam', '0903598304', 'Male', '1979-12-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (65, N'Hoang Phuong Yen', '0989018685', 'Female', '1991-01-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (66, N'Hoang Quoc Toan', '0968750731', 'Male', '1990-12-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (67, N'Ngo The Nam', '0980099182', 'Male', '1975-11-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (68, N'Nguyen Van Long', '0990351100', 'Male', '1986-02-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (69, N'Vu Quang Thai', '0970858748', 'Male', '2000-09-09', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (70, N'Tran Ngoc Chi', '0950294314', 'Female', '1977-08-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (71, N'Bui Duc Lam', '0909012337', 'Male', '1983-01-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (72, N'Le Thi Huyen', '0902900015', 'Female', '1974-09-10', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (73, N'Ngo Minh Thinh', '0972390516', 'Male', '1985-07-12', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (74, N'Ly Duy Thang', '0935689026', 'Male', '1988-02-06', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (75, N'Dang Xuan Hai', '0961741262', 'Male', '1988-03-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (76, N'Hoang Kim Yen', '0998255805', 'Female', '1990-04-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (77, N'Ngo Xuan Giang', '0926214503', 'Male', '1999-02-10', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (78, N'Duong Phuong Linh', '0981010199', 'Female', '1978-07-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (79, N'Le Hong Hanh', '0903469641', 'Female', '1972-04-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (80, N'Vo Thanh Yen', '0984098794', 'Female', '2001-12-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (81, N'Ly Ngoc Lan', '0941354907', 'Female', '1977-06-04', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (82, N'Duong Thu Mai', '0964406510', 'Female', '1976-03-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (83, N'Hoang Minh Hieu', '0961873319', 'Male', '1986-05-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (84, N'Le Duc Cuong', '0914952187', 'Male', '1975-08-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (85, N'Dang Anh Trung', '0933289428', 'Male', '1983-04-16', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (86, N'Tran Duy Hoang', '0970706186', 'Male', '2004-05-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (87, N'Pham Kim Vy', '0904475712', 'Female', '2004-01-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (88, N'Pham Khanh Yen', '0994383732', 'Female', '2001-05-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (89, N'Vu Thu Thao', '0925797218', 'Female', '2003-04-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (90, N'Do Hong Trinh', '0909849795', 'Female', '2000-02-06', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (91, N'Pham Thu Nga', '0987011544', 'Female', '2005-08-25', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (92, N'Duong Thi Nhi', '0926291628', 'Female', '2005-11-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (93, N'Hoang Van Dat', '0903652749', 'Male', '2003-09-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (94, N'Tran My Nhung', '0941575349', 'Female', '2001-10-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (95, N'Vo Kim Thao', '0908199630', 'Female', '2004-12-19', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (96, N'Tran Vy My', '0972173067', 'Female', '2003-01-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (97, N'Nguyen Quang Thinh', '0960436666', 'Male', '2005-12-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (98, N'Ly Anh Toan', '0984845362', 'Male', '2001-03-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (99, N'Nguyen Quang Quan', '0986650271', 'Male', '2004-08-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (100, N'Le Van Thai', '0919420660', 'Male', '2003-03-19', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (101, N'Vo Huu Quan', '0967654264', 'Male', '2005-06-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (102, N'Tran The Anh', '0957619948', 'Male', '2001-05-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (103, N'Hoang Thu Lan', '0910352000', 'Female', '2005-01-25', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (104, N'Phan Xuan Tuan', '0977275480', 'Male', '2004-03-17', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (105, N'Vo Ngoc Vy', '0973062485', 'Female', '2000-11-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (106, N'Tran Thanh Khoa', '0951378646', 'Male', '2004-07-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (107, N'Nguyen Phuong Mai', '0984285906', 'Female', '2000-06-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (108, N'Ly Thanh Tuan', '0976346085', 'Male', '2002-08-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (109, N'Ho Lan Thao', '0926715492', 'Female', '2001-09-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (110, N'Duong Vy Oanh', '0989495077', 'Female', '2001-10-07', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (111, N'Nguyen Viet Tuan', '0958498111', 'Male', '2002-06-04', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (112, N'Do Thanh Hanh', '0982455129', 'Female', '2005-08-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (113, N'Do Duy Hai', '0998780526', 'Male', '2004-09-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (114, N'Duong Thanh Long', '0937110901', 'Male', '2002-10-17', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (115, N'Phan Anh Quan', '0993678708', 'Male', '2000-01-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (116, N'Ly My An', '0942772469', 'Female', '2000-11-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (117, N'Le Van Thang', '0954508723', 'Male', '2003-12-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (118, N'Nguyen Khanh Phuong', '0967166471', 'Female', '2005-02-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (119, N'Phan Quang Dung', '0909969788', 'Male', '2000-11-03', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (120, N'Hoang Thanh Tuan', '0998807820', 'Male', '2002-07-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (121, N'Vu Ngoc An', '0992642908', 'Female', '2004-09-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (122, N'Ho The Trung', '0938546983', 'Male', '2000-06-16', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (123, N'Pham The Quan', '0971746486', 'Male', '2000-09-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (124, N'Vu Quoc Nghia', '0977027257', 'Male', '2001-09-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (125, N'Duong Xuan Thinh', '0988080256', 'Male', '2002-07-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (126, N'Ngo Quang Thang', '0995858604', 'Male', '2005-02-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (127, N'Le Xuan Viet', '0998630004', 'Male', '2000-03-12', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (128, N'Dang Dinh Khoa', '0973216944', 'Male', '2002-01-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (129, N'Phan Viet Quan', '0977018320', 'Male', '2002-09-12', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (130, N'Vo Lan Huong', '0926696344', 'Female', '2005-10-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (131, N'Ngo Duy Toan', '0910035762', 'Male', '2000-05-17', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (132, N'Ngo Lan Linh', '0952811564', 'Female', '2004-12-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (133, N'Ho Quoc Anh', '0939235554', 'Male', '2001-07-19', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (134, N'Dang Duy Hung', '0942955487', 'Male', '2000-05-08', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (135, N'Dang Thanh An', '0966211438', 'Female', '2004-12-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (136, N'Vo Thu Ha', '0998572295', 'Female', '2004-03-17', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (137, N'Duong Duy Son', '0972265750', 'Male', '2004-08-20', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (138, N'Hoang Thi Hoa', '0941062724', 'Female', '2003-08-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (139, N'Ly Hong Huyen', '0922821929', 'Female', '2002-04-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (140, N'Dang Quang Giang', '0981574888', 'Male', '2005-08-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (141, N'Vu Anh Hai', '0912186919', 'Male', '2004-10-25', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (142, N'Nguyen Duc Hoang', '0937231198', 'Male', '2003-05-20', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (143, N'Phan Viet Quan', '0916497658', 'Male', '2001-10-26', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (144, N'Vo My My', '0953106326', 'Female', '2003-08-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (145, N'Pham My Ha', '0994265681', 'Female', '2002-09-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (146, N'Hoang Thanh Hung', '0900296633', 'Male', '2003-01-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (147, N'Hoang Viet Thinh', '0953448650', 'Male', '2004-03-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (148, N'Duong Ngoc Vy', '0977067882', 'Female', '2005-03-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (149, N'Ho Hong Linh', '0966935579', 'Female', '2005-04-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (150, N'Do Ngoc Dung', '0930944024', 'Female', '2000-07-10', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (151, N'Vu Xuan Hieu', '0995592753', 'Male', '2004-07-21', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (152, N'Nguyen Ngoc Huyen', '0986204898', 'Female', '2004-02-09', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (153, N'Ngo Minh Duy', '0987281601', 'Male', '2005-03-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (154, N'Ho Hong Hanh', '0906576600', 'Female', '2000-05-11', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (155, N'Bui Quang Nghia', '0993932140', 'Male', '2004-01-22', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (156, N'Dang Phuong Oanh', '0988166994', 'Female', '2005-11-27', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (157, N'Ho Khanh Ngoc', '0995828033', 'Female', '2005-06-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (158, N'Hoang Quang Thang', '0929166959', 'Male', '2001-05-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (159, N'Hoang Huu Hung', '0947471865', 'Male', '2000-05-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (160, N'Hoang Vy Anh', '0930474165', 'Female', '2002-11-24', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (161, N'Ngo Khanh Hanh', '0996519679', 'Female', '2001-07-23', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (162, N'Ngo Viet Quan', '0989249043', 'Male', '2002-01-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (163, N'Vu Xuan Toan', '0965361361', 'Male', '2003-05-27', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (164, N'Tran Kim Oanh', '0912906144', 'Female', '2003-04-19', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (165, N'Le My Lan', '0910211350', 'Female', '2000-02-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (166, N'Ngo Ngoc Vy', '0905654391', 'Female', '2005-12-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (167, N'Bui Lan My', '0987096640', 'Female', '2002-10-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (168, N'Ho Ngoc Vy', '0998170455', 'Female', '2000-10-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (169, N'Do Quang Hung', '0989340221', 'Male', '2005-07-05', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (170, N'Vo Ngoc Thao', '0943772592', 'Female', '2002-11-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (171, N'Nguyen Viet Thanh', '0955507810', 'Male', '2003-10-27', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (172, N'Tran Thu Lan', '0931499256', 'Female', '2004-01-13', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (173, N'Bui Anh Thang', '0901877842', 'Male', '2000-01-06', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (174, N'Dang Duc Long', '0971245109', 'Male', '2003-04-17', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (175, N'Ngo Hong My', '0997898557', 'Female', '2004-10-28', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (176, N'Tran Hong Trinh', '0918931668', 'Female', '2004-09-15', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (177, N'Vu Thanh Anh', '0944996232', 'Female', '2002-06-27', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (178, N'Bui My Lan', '0910036740', 'Female', '2000-01-23', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (179, N'Le The Phong', '0911332471', 'Male', '2003-05-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (180, N'Pham Khanh An', '0950236126', 'Female', '2001-05-14', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (181, N'Hoang Kim Diep', '0995984680', 'Female', '2004-11-18', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (182, N'Ly Huu Phong', '0931172065', 'Male', '2005-08-23', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (183, N'Duong Duc Dung', '0995071156', 'Male', '2001-09-02', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (184, N'Phan Viet Giang', '0903389756', 'Male', '2000-01-16', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (185, N'Do Minh Hoang', '0969281798', 'Male', '2004-09-20', GETDATE(), DATEADD(year, 4, GETDATE()));

-- ------------------------------------------------------------
-- 7. ROLE SPECIFIC TABLES (Admin, LibraryManager, Librarian, Lecturer, Student)
-- ------------------------------------------------------------
-- Admin Specific
INSERT INTO Admin (userId, staffCode) VALUES (1, 'AD001');
INSERT INTO Admin (userId, staffCode) VALUES (2, 'AD002');
INSERT INTO Admin (userId, staffCode) VALUES (3, 'AD003');
INSERT INTO Admin (userId, staffCode) VALUES (4, 'AD004');
INSERT INTO Admin (userId, staffCode) VALUES (5, 'AD005');

-- Library Manager Specific
INSERT INTO LibraryManager (userId, staffCode) VALUES (6, 'MN001');
INSERT INTO LibraryManager (userId, staffCode) VALUES (7, 'MN002');
INSERT INTO LibraryManager (userId, staffCode) VALUES (8, 'MN003');
INSERT INTO LibraryManager (userId, staffCode) VALUES (9, 'MN004');
INSERT INTO LibraryManager (userId, staffCode) VALUES (10, 'MN005');
INSERT INTO LibraryManager (userId, staffCode) VALUES (11, 'MN006');
INSERT INTO LibraryManager (userId, staffCode) VALUES (12, 'MN007');
INSERT INTO LibraryManager (userId, staffCode) VALUES (13, 'MN008');
INSERT INTO LibraryManager (userId, staffCode) VALUES (14, 'MN009');
INSERT INTO LibraryManager (userId, staffCode) VALUES (15, 'MN010');

-- Librarian Specific
INSERT INTO Librarian (userId, staffCode) VALUES (16, 'LB001');
INSERT INTO Librarian (userId, staffCode) VALUES (17, 'LB002');
INSERT INTO Librarian (userId, staffCode) VALUES (18, 'LB003');
INSERT INTO Librarian (userId, staffCode) VALUES (19, 'LB004');
INSERT INTO Librarian (userId, staffCode) VALUES (20, 'LB005');
INSERT INTO Librarian (userId, staffCode) VALUES (21, 'LB006');
INSERT INTO Librarian (userId, staffCode) VALUES (22, 'LB007');
INSERT INTO Librarian (userId, staffCode) VALUES (23, 'LB008');
INSERT INTO Librarian (userId, staffCode) VALUES (24, 'LB009');
INSERT INTO Librarian (userId, staffCode) VALUES (25, 'LB010');
INSERT INTO Librarian (userId, staffCode) VALUES (26, 'LB011');
INSERT INTO Librarian (userId, staffCode) VALUES (27, 'LB012');
INSERT INTO Librarian (userId, staffCode) VALUES (28, 'LB013');
INSERT INTO Librarian (userId, staffCode) VALUES (29, 'LB014');
INSERT INTO Librarian (userId, staffCode) VALUES (30, 'LB015');
INSERT INTO Librarian (userId, staffCode) VALUES (31, 'LB016');
INSERT INTO Librarian (userId, staffCode) VALUES (32, 'LB017');
INSERT INTO Librarian (userId, staffCode) VALUES (33, 'LB018');
INSERT INTO Librarian (userId, staffCode) VALUES (34, 'LB019');
INSERT INTO Librarian (userId, staffCode) VALUES (35, 'LB020');

-- Lecturer Specific
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (36, 'LEC001', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (37, 'LEC002', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (38, 'LEC003', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (39, 'LEC004', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (40, 'LEC005', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (41, 'LEC006', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (42, 'LEC007', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (43, 'LEC008', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (44, 'LEC009', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (45, 'LEC010', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (46, 'LEC011', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (47, 'LEC012', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (48, 'LEC013', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (49, 'LEC014', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (50, 'LEC015', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (51, 'LEC016', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (52, 'LEC017', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (53, 'LEC018', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (54, 'LEC019', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (55, 'LEC020', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (56, 'LEC021', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (57, 'LEC022', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (58, 'LEC023', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (59, 'LEC024', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (60, 'LEC025', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (61, 'LEC026', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (62, 'LEC027', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (63, 'LEC028', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (64, 'LEC029', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (65, 'LEC030', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (66, 'LEC031', N'Social Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (67, 'LEC032', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (68, 'LEC033', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (69, 'LEC034', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (70, 'LEC035', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (71, 'LEC036', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (72, 'LEC037', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (73, 'LEC038', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (74, 'LEC039', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (75, 'LEC040', N'Information Technology');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (76, 'LEC041', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (77, 'LEC042', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (78, 'LEC043', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (79, 'LEC044', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (80, 'LEC045', N'Foreign Languages');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (81, 'LEC046', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (82, 'LEC047', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (83, 'LEC048', N'Economic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (84, 'LEC049', N'Basic Sciences');
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (85, 'LEC050', N'Foreign Languages');

-- Student Specific
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (86, 'HE180001', N'Business Administration', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (87, 'HE180002', N'Hospitality Management', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (88, 'HE180003', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (89, 'HE180004', N'Hospitality Management', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (90, 'HE180005', N'Graphic Design', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (91, 'HE180006', N'Software Engineering', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (92, 'HE180007', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (93, 'HE180008', N'Information Assurance', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (94, 'HE180009', N'Computer Science', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (95, 'HE180010', N'Business Administration', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (96, 'HE180011', N'Software Engineering', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (97, 'HE180012', N'Software Engineering', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (98, 'HE180013', N'Hospitality Management', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (99, 'HE180014', N'Information Assurance', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (100, 'HE180015', N'Computer Science', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (101, 'HE180016', N'Hospitality Management', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (102, 'HE180017', N'Software Engineering', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (103, 'HE180018', N'Business Administration', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (104, 'HE180019', N'Computer Science', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (105, 'HE180020', N'Business Administration', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (106, 'HE180021', N'Business Administration', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (107, 'HE180022', N'Business Administration', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (108, 'HE180023', N'Hospitality Management', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (109, 'HE180024', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (110, 'HE180025', N'Computer Science', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (111, 'HE180026', N'Business Administration', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (112, 'HE180027', N'Business Administration', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (113, 'HE180028', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (114, 'HE180029', N'Computer Science', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (115, 'HE180030', N'International Business', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (116, 'HE180031', N'Graphic Design', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (117, 'HE180032', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (118, 'HE180033', N'Hospitality Management', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (119, 'HE180034', N'Information Assurance', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (120, 'HE180035', N'Hospitality Management', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (121, 'HE180036', N'Business Administration', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (122, 'HE180037', N'Information Assurance', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (123, 'HE180038', N'Graphic Design', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (124, 'HE180039', N'Hospitality Management', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (125, 'HE180040', N'Graphic Design', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (126, 'HE180041', N'Graphic Design', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (127, 'HE180042', N'International Business', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (128, 'HE180043', N'Software Engineering', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (129, 'HE180044', N'Information Assurance', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (130, 'HE180045', N'Graphic Design', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (131, 'HE180046', N'International Business', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (132, 'HE180047', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (133, 'HE180048', N'International Business', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (134, 'HE180049', N'Information Assurance', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (135, 'HE180050', N'Software Engineering', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (136, 'HE180051', N'Information Assurance', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (137, 'HE180052', N'Information Assurance', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (138, 'HE180053', N'Graphic Design', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (139, 'HE180054', N'Information Assurance', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (140, 'HE180055', N'Graphic Design', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (141, 'HE180056', N'Hospitality Management', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (142, 'HE180057', N'Graphic Design', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (143, 'HE180058', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (144, 'HE180059', N'Software Engineering', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (145, 'HE180060', N'Hospitality Management', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (146, 'HE180061', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (147, 'HE180062', N'Graphic Design', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (148, 'HE180063', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (149, 'HE180064', N'International Business', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (150, 'HE180065', N'Hospitality Management', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (151, 'HE180066', N'Business Administration', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (152, 'HE180067', N'Software Engineering', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (153, 'HE180068', N'Software Engineering', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (154, 'HE180069', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (155, 'HE180070', N'Business Administration', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (156, 'HE180071', N'Graphic Design', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (157, 'HE180072', N'Graphic Design', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (158, 'HE180073', N'Computer Science', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (159, 'HE180074', N'Business Administration', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (160, 'HE180075', N'Information Assurance', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (161, 'HE180076', N'Computer Science', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (162, 'HE180077', N'Hospitality Management', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (163, 'HE180078', N'Information Assurance', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (164, 'HE180079', N'Graphic Design', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (165, 'HE180080', N'Hospitality Management', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (166, 'HE180081', N'Graphic Design', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (167, 'HE180082', N'Graphic Design', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (168, 'HE180083', N'Software Engineering', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (169, 'HE180084', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (170, 'HE180085', N'Computer Science', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (171, 'HE180086', N'Computer Science', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (172, 'HE180087', N'Software Engineering', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (173, 'HE180088', N'International Business', 2023);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (174, 'HE180089', N'Business Administration', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (175, 'HE180090', N'Information Assurance', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (176, 'HE180091', N'International Business', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (177, 'HE180092', N'Business Administration', 2022);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (178, 'HE180093', N'Information Assurance', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (179, 'HE180094', N'Hospitality Management', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (180, 'HE180095', N'Computer Science', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (181, 'HE180096', N'Business Administration', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (182, 'HE180097', N'Computer Science', 2024);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (183, 'HE180098', N'Graphic Design', 2020);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (184, 'HE180099', N'International Business', 2021);
INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (185, 'HE180100', N'Computer Science', 2020);

-- ------------------------------------------------------------
-- 7. ADDITIONAL USERS FOR GOOGLE SSO TEST
-- ------------------------------------------------------------
SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (186, 'caotuan01122005@gmail.com', '$2a$10$C1T/jl2S/N69KiAxLCInLuOz/8x41wu3vwAzVBHCfxtBhCIwTihNO', 'active', 'admin', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (187, 'caothanhtuan576@gmail.com', '$2a$10$iBRzHURbhQJvBL3PZVmHj.ox8ytWBfRtETotH8BVViBoobZYlvJe6', 'active', 'student', 0, NULL);
INSERT INTO [User] (userId, email, passwordHash, [status], [role], failedLoginAttempts, lockedUntil) VALUES (188, 'vuvanquyet0305@gmail.com', '$2a$10$293gfAe0o6HG1jyFTsKOMuuMJtYiWloQm19PIBL55BCOJyLSKiis2', 'active', 'lecturer', 0, NULL);
SET IDENTITY_INSERT [User] OFF;

INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (186, N'Cao Tuan Admin', '0123456789', 'Male', '2005-12-01', NULL, NULL);
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (187, N'Cao Thanh Tuan Student', '0123456788', 'Male', '2000-01-01', GETDATE(), DATEADD(year, 4, GETDATE()));
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) VALUES (188, N'Vu Van Quyet Lecturer', '0123456787', 'Male', '1990-05-03', GETDATE(), DATEADD(year, 4, GETDATE()));

INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (187, 'HE999999', N'Software Engineering', 2023);
INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (188, 'LEC999', N'Information Technology');

INSERT INTO SystemConfigurations (configKey, configValue, description)
VALUES ('GEMINI_API_KEY', 'YOUR_GEMINI_API_KEY', N'API Key cho Google Gemini AI Recommendation');

USE LMS_Library_Management_System;
GO

-- ------------------------------------------------------------
-- 1. CLEANUP OLD TEST DATA
-- ------------------------------------------------------------
DELETE FROM BorrowRecord WHERE borrowRecordId BETWEEN 1 AND 30;
DELETE FROM BookCopy WHERE bookCopyId BETWEEN 1 AND 150;
DELETE FROM BookTag WHERE bookId BETWEEN 1 AND 75;
DELETE FROM BookCategory WHERE bookId BETWEEN 1 AND 75;
DELETE FROM Book WHERE bookId BETWEEN 1 AND 75;
DELETE FROM Tag WHERE tagId BETWEEN 1 AND 15;
DELETE FROM Category WHERE categoryId BETWEEN 1 AND 6;

-- ------------------------------------------------------------
-- 2. INSERT CATEGORIES (6 CATEGORIES)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (categoryId, name, description) VALUES 
(1, N'Programming Languages', N'Sách về các ngôn ngữ lập trình phổ biến'),
(2, N'Software Architecture', N'Sách về thiết kế kiến trúc và mẫu thiết kế phần mềm'),
(3, N'Databases & SQL', N'Sách về cơ sở dữ liệu quan hệ, NoSQL và SQL tối ưu'),
(4, N'Web Development', N'Sách phát triển giao diện và ứng dụng web (React, Node, JS)'),
(5, N'DevOps & Cloud', N'Sách về điện toán đám mây, Docker, Kubernetes và CI/CD'),
(6, N'AI & Data Science', N'Sách về Trí tuệ nhân tạo, Machine Learning và Khoa học dữ liệu');
SET IDENTITY_INSERT Category OFF;

-- ------------------------------------------------------------
-- 3. INSERT TAGS (15 TAGS)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Tag ON;
INSERT INTO Tag (tagId, name) VALUES 
(1, 'Java'),
(2, 'Python'),
(3, 'Go'),
(4, 'C++'),
(5, 'JavaScript'),
(6, 'React'),
(7, 'Node.js'),
(8, 'Architecture'),
(9, 'Design Patterns'),
(10, 'Microservices'),
(11, 'SQL'),
(12, 'NoSQL'),
(13, 'Docker & Kubernetes'),
(14, 'Cloud Native'),
(15, 'Machine Learning');
SET IDENTITY_INSERT Tag OFF;

-- ------------------------------------------------------------
-- 4. INSERT BOOKS (75 BOOKS)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Book ON;
INSERT INTO Book (bookId, isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, [status]) VALUES 
-- Category 1: Programming Languages (1-8, 46-48)
(1, '978-0134685991', N'Effective Java', N'Joshua Bloch', N'Addison-Wesley', 2017, 45.00, 2, 2, 'available'),
(2, '978-0596009205', N'Head First Java', N'Kathy Sierra', N'O''Reilly Media', 2005, 30.00, 2, 2, 'available'),
(3, '978-1449331818', N'Learning Python', N'Mark Lutz', N'O''Reilly Media', 2013, 55.00, 2, 2, 'available'),
(4, '978-1491946008', N'Fluent Python', N'Luciano Ramalho', N'O''Reilly Media', 2015, 60.00, 2, 2, 'available'),
(5, '978-1453916701', N'The Go Programming Language', N'Alan A. A. Donovan', N'Addison-Wesley', 2015, 49.00, 2, 2, 'available'),
(6, '978-1449311605', N'Programming in Go', N'Mark Summerfield', N'Addison-Wesley', 2012, 45.00, 2, 2, 'available'),
(7, '978-0321714114', N'C++ Primer', N'Stanley B. Lippman', N'Addison-Wesley', 2012, 50.00, 2, 2, 'available'),
(8, '978-0131103627', N'The C Programming Language', N'Brian W. Kernighan', N'Prentice Hall', 1988, 40.00, 2, 2, 'available'),

-- Category 2: Software Architecture (9-16, 49-51)
(9, '978-0134494166', N'Clean Architecture', N'Robert C. Martin', N'Prentice Hall', 2017, 42.00, 2, 2, 'available'),
(10, '978-0321125217', N'Domain-Driven Design', N'Eric Evans', N'Addison-Wesley', 2003, 50.00, 2, 2, 'available'),
(11, '978-0201633610', N'Design Patterns', N'Erich Gamma', N'Addison-Wesley', 1994, 55.00, 2, 2, 'available'),
(12, '978-1491956250', N'Building Microservices', N'Sam Newman', N'O''Reilly Media', 2015, 48.00, 2, 2, 'available'),
(13, '978-1617294549', N'Microservices Patterns', N'Chris Richardson', N'Manning', 2018, 52.00, 2, 2, 'available'),
(14, '978-1449373320', N'Designing Data-Intensive Applications', N'Martin Kleppmann', N'O''Reilly Media', 2017, 48.00, 2, 2, 'available'),
(15, '978-1492056812', N'Fundamentals of Software Architecture', N'Mark Richards', N'O''Reilly Media', 2020, 55.00, 2, 2, 'available'),
(16, '978-0321127426', N'Patterns of Enterprise Application Architecture', N'Martin Fowler', N'Addison-Wesley', 2002, 58.00, 2, 2, 'available'),

-- Category 3: Databases & SQL (17-24, 52-54)
(17, '978-0134858333', N'SQL Queries for Mere Mortals', N'John L. Viescas', N'Addison-Wesley', 2018, 40.00, 2, 2, 'available'),
(18, '978-1449314286', N'High Performance MySQL', N'Baron Schwartz', N'O''Reilly Media', 2012, 45.00, 2, 2, 'available'),
(19, '978-1491954461', N'MongoDB: The Definitive Guide', N'Shannon Bradshaw', N'O''Reilly Media', 2019, 46.00, 2, 2, 'available'),
(20, '978-1449310301', N'NoSQL Distilled', N'Pramod J. Sadalage', N'Addison-Wesley', 2012, 38.00, 2, 2, 'available'),
(21, '978-1492057611', N'Learning SQL', N'Alan Beaulieu', N'O''Reilly Media', 2020, 39.00, 2, 2, 'available'),
(22, '978-1492004738', N'SQL Cookbook', N'Anthony Molinaro', N'O''Reilly Media', 2020, 48.00, 2, 2, 'available'),
(23, '978-1449309398', N'Seven Databases in Seven Weeks', N'Eric Redmond', N'Pragmatic Bookshelf', 2012, 40.00, 2, 2, 'available'),
(24, '978-0073523323', N'Database System Concepts', N'Abraham Silberschatz', N'McGraw-Hill', 2010, 75.00, 2, 2, 'available'),

-- Category 4: Web Development (25-32, 55-57)
(25, '978-0596517748', N'JavaScript: The Good Parts', N'Douglas Crockford', N'O''Reilly Media', 2008, 25.00, 2, 2, 'available'),
(26, '978-1492054375', N'You Don''t Know JS Yet', N'Kyle Simpson', N'O''Reilly Media', 2020, 30.00, 2, 2, 'available'),
(27, '978-1732329393', N'Eloquent JavaScript', N'Marijn Haverbeke', N'No Starch Press', 2018, 35.00, 2, 2, 'available'),
(28, '978-1492082904', N'Learning React', N'Alex Banks', N'O''Reilly Media', 2020, 45.00, 2, 2, 'available'),
(29, '978-1484254585', N'Pro React 16', N'Adam Freeman', N'Apress', 2019, 49.00, 2, 2, 'available'),
(30, '978-1839214110', N'Node.js Design Patterns', N'Mario Casciaro', N'Packt', 2020, 50.00, 2, 2, 'available'),
(31, '978-1492053514', N'Web Development with Node and Express', N'Ethan Brown', N'O''Reilly Media', 2019, 42.00, 2, 2, 'available'),
(32, '978-1543997675', N'Beginning Node.js, Express & MongoDB', N'Greg Lim', N'Greg Lim Publishing', 2020, 25.00, 2, 2, 'available'),

-- Category 5: DevOps & Cloud (33-39, 58-60)
(33, '978-1942788003', N'The DevOps Handbook', N'Gene Kim', N'IT Revolution Press', 2016, 45.00, 2, 2, 'available'),
(34, '978-1916585126', N'Docker Deep Dive', N'Nigel Poulton', N'Nigel Poulton Publishing', 2020, 38.00, 2, 2, 'available'),
(35, '978-1492003290', N'Kubernetes Up and Running', N'Kelsey Hightower', N'O''Reilly Media', 2019, 45.00, 2, 2, 'available'),
(36, '978-1119504221', N'AWS Certified Solutions Architect Study Guide', N'Ben Piper', N'Sybex', 2019, 50.00, 2, 2, 'available'),
(37, '978-1617294006', N'Cloud Native Patterns', N'Cornelia Davis', N'Manning', 2019, 47.00, 2, 2, 'available'),
(38, '978-1492046905', N'Terraform: Up & Running', N'Yevgeniy Brikman', N'O''Reilly Media', 2019, 45.00, 2, 2, 'available'),
(39, '978-1491929124', N'Site Reliability Engineering', N'Betsy Beyer', N'O''Reilly Media', 2016, 49.00, 2, 2, 'available'),

-- Category 6: AI & Data Science (40-45, 61-75)
(40, '978-1492032649', N'Hands-On Machine Learning', N'Aurélien Géron', N'O''Reilly Media', 2019, 65.00, 2, 2, 'available'),
(41, '978-1491957660', N'Python for Data Analysis', N'Wes McKinney', N'O''Reilly Media', 2017, 50.00, 2, 2, 'available'),
(42, '978-1492041139', N'Data Science from Scratch', N'Joel Grus', N'O''Reilly Media', 2019, 40.00, 2, 2, 'available'),
(43, '978-1492051053', N'Introduction to Machine Learning with Python', N'Andreas C. Müller', N'O''Reilly Media', 2020, 48.00, 2, 2, 'available'),
(44, '978-1462935513', N'Deep Learning', N'Ian Goodfellow', N'MIT Press', 2016, 80.00, 2, 2, 'available'),
(45, '978-1108488051', N'Mathematics for Machine Learning', N'Marc Peter Deisenroth', N'Cambridge University Press', 2020, 55.00, 2, 2, 'available'),

-- Category 1 (Added)
(46, '978-0135111529', N'Core Java Volume I--Fundamentals', N'Cay S. Horstmann', N'Pearson', 2018, 48.00, 2, 2, 'available'),
(47, '978-0321334879', N'Effective C++', N'Scott Meyers', N'Addison-Wesley', 2005, 45.00, 2, 2, 'available'),
(48, '978-0131872486', N'Thinking in Java', N'Bruce Eckel', N'Prentice Hall', 2006, 50.00, 2, 2, 'available'),

-- Category 2 (Added)
(49, '978-1492086895', N'Software Architecture: The Hard Parts', N'Neal Ford', N'O''Reilly Media', 2021, 54.00, 2, 2, 'available'),
(50, '978-0321200686', N'Enterprise Integration Patterns', N'Gregor Hohpe', N'Addison-Wesley', 2003, 58.00, 2, 2, 'available'),
(51, '978-1736049112', N'System Design Interview', N'Alex Xu', N'ByteByteGo', 2020, 39.00, 2, 2, 'available'),

-- Category 3 (Added)
(52, '978-1540801821', N'SQL Practice Problems', N'Sylvia Moestl Vasilik', N'Independently Published', 2016, 20.00, 2, 2, 'available'),
(53, '978-0134023212', N'NoSQL for Mere Mortals', N'Dan Sullivan', N'Addison-Wesley', 2015, 42.00, 2, 2, 'available'),
(54, '978-3950307825', N'SQL Performance Explained', N'Markus Winand', N'Markus Winand', 2012, 35.00, 2, 2, 'available'),

-- Category 4 (Added)
(55, '978-1118008188', N'HTML and CSS: Design and Build Websites', N'Jon Duckett', N'Wiley', 2011, 29.00, 2, 2, 'available'),
(56, '978-1803234502', N'React Key Concepts', N'Maximilian Schwarzmüller', N'Packt', 2022, 38.00, 2, 2, 'available'),
(57, '978-1838987589', N'Node.js Web Development', N'David Herron', N'Packt', 2020, 44.00, 2, 2, 'available'),

-- Category 5 (Added)
(58, '978-1491979440', N'Kubernetes Cookbook', N'Sébastien Goasguen', N'O''Reilly Media', 2018, 46.00, 2, 2, 'available'),
(59, '978-1492029420', N'Implementing Service Quality', N'SRE Team', N'O''Reilly Media', 2019, 45.00, 2, 2, 'available'),
(60, '978-1119756163', N'AWS Certified Cloud Practitioner', N'CLF', N'Sybex', 2021, 30.00, 2, 2, 'available'),

-- Category 6 (Added)
(61, '978-1466575577', N'Introduction to Probability', N'Joseph K. Blitzstein', N'Chapman and Hall/CRC', 2019, 75.00, 2, 2, 'available'),
(62, '978-0387310732', N'Pattern Recognition and Machine Learning', N'Christopher M. Bishop', N'Springer', 2006, 95.00, 2, 2, 'available'),
(63, '978-0986001002', N'Neural Networks and Deep Learning', N'Michael Nielsen', N'Determination Press', 2015, 30.00, 2, 2, 'available'),
(64, '978-1491907337', N'Think Stats', N'Allen B. Downey', N'O''Reilly Media', 2014, 35.00, 2, 2, 'available'),
(65, '978-1491912058', N'Python Data Science Handbook', N'Jake VanderPlas', N'O''Reilly Media', 2016, 55.00, 2, 2, 'available'),
(66, '978-1617294433', N'Deep Learning with Python', N'François Chollet', N'Manning', 2017, 50.00, 2, 2, 'available'),
(67, '978-1098103248', N'Natural Language Processing with Transformers', N'Lewis Tunstall', N'O''Reilly Media', 2022, 58.00, 2, 2, 'available'),
(68, '978-0262039245', N'Reinforcement Learning', N'Richard S. Sutton', N'MIT Press', 2018, 90.00, 2, 2, 'available'),
(69, '978-1800563452', N'Hands-On Data Analysis with Pandas', N'Stefanie Molin', N'Packt', 2021, 40.00, 2, 2, 'available'),
(70, '978-1491953242', N'Feature Engineering for Machine Learning', N'Alice Zheng', N'O''Reilly Media', 2018, 38.00, 2, 2, 'available'),
(71, '978-0486832869', N'Introduction to Artificial Intelligence', N'Philip C Jackson', N'Dover Publications', 2019, 18.00, 2, 2, 'available'),
(72, '978-0134610993', N'Artificial Intelligence: A Modern Approach', N'Stuart Russell', N'Pearson', 2020, 120.00, 2, 2, 'available'),
(73, '978-1492072942', N'Practical Statistics for Data Scientists', N'Peter Bruce', N'O''Reilly Media', 2020, 42.00, 2, 2, 'available'),
(74, '978-1492079361', N'Data Science on AWS', N'Chris Fregly', N'O''Reilly Media', 2021, 58.00, 2, 2, 'available'),
(75, '978-1098115784', N'Machine Learning Design Patterns', N'Lakshmanan', N'O''Reilly Media', 2021, 55.00, 2, 2, 'available');
SET IDENTITY_INSERT Book OFF;

-- ------------------------------------------------------------
-- 5. INSERT BOOK CATEGORIES (75 BOOKS)
-- ------------------------------------------------------------
INSERT INTO BookCategory (bookId, categoryId) VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
(9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2), (15, 2), (16, 2),
(17, 3), (18, 3), (19, 3), (20, 3), (21, 3), (22, 3), (23, 3), (24, 3),
(25, 4), (26, 4), (27, 4), (28, 4), (29, 4), (30, 4), (31, 4), (32, 4),
(33, 5), (34, 5), (35, 5), (36, 5), (37, 5), (38, 5), (39, 5),
(40, 6), (41, 6), (42, 6), (43, 6), (44, 6), (45, 6),
(46, 1), (47, 1), (48, 1),
(49, 2), (50, 2), (51, 2),
(52, 3), (53, 3), (54, 3),
(55, 4), (56, 4), (57, 4),
(58, 5), (59, 5), (60, 5),
(61, 6), (62, 6), (63, 6), (64, 6), (65, 6), (66, 6), (67, 6), (68, 6), (69, 6), (70, 6), (71, 6), (72, 6), (73, 6), (74, 6), (75, 6);

-- ------------------------------------------------------------
-- 6. INSERT BOOK TAGS
-- ------------------------------------------------------------
INSERT INTO BookTag (bookId, tagId) VALUES 
-- Programming Languages
(1, 1), (1, 9),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
-- Software Architecture
(9, 8), (9, 9),
(10, 8), (10, 9),
(11, 9),
(12, 10), (12, 14),
(13, 10), (13, 9),
(14, 8), (14, 10),
(15, 8),
(16, 8), (16, 9),
-- Databases & SQL
(17, 11),
(18, 11),
(19, 12),
(20, 12),
(21, 11),
(22, 11),
(23, 11), (23, 12),
(24, 11),
-- Web Development
(25, 5),
(26, 5),
(27, 5),
(28, 6), (28, 5),
(29, 6),
(30, 7), (30, 9),
(31, 7), (31, 5),
(32, 7), (32, 12),
-- DevOps & Cloud
(33, 14),
(34, 13),
(35, 13), (35, 14),
(36, 14),
(37, 14), (37, 10),
(38, 14),
(39, 14),
-- AI & Data Science
(40, 15), (40, 2),
(41, 2),
(42, 15), (42, 2),
(43, 15), (43, 2),
(44, 15),
(45, 15),
-- Added Books Tags
(46, 1),
(47, 4),
(48, 1), (48, 9),
(49, 8), (49, 10),
(50, 8), (50, 9),
(51, 8),
(52, 11),
(53, 12),
(54, 11),
(55, 5),
(56, 6), (56, 5),
(57, 7), (57, 5),
(58, 13), (58, 14),
(59, 14),
(60, 14),
(61, 15),
(62, 15),
(63, 15),
(64, 2),
(65, 2), (65, 15),
(66, 2), (66, 15),
(67, 15), (67, 2),
(68, 15),
(69, 2), (69, 11),
(70, 15), (70, 2),
(71, 15),
(72, 15),
(73, 2),
(74, 14), (74, 15),
(75, 15), (75, 9);

-- ------------------------------------------------------------
-- 7. INSERT BOOK COPIES (75 BOOKS * 2 COPIES = 150 COPIES)
-- ------------------------------------------------------------
SET IDENTITY_INSERT BookCopy ON;
INSERT INTO BookCopy (bookCopyId, bookId, barcode, condition, [status]) VALUES 
(1, 1, 'BC-001-1', 'good', 'available'), (2, 1, 'BC-001-2', 'good', 'available'),
(3, 2, 'BC-002-1', 'good', 'available'), (4, 2, 'BC-002-2', 'good', 'available'),
(5, 3, 'BC-003-1', 'good', 'available'), (6, 3, 'BC-003-2', 'good', 'available'),
(7, 4, 'BC-004-1', 'good', 'available'), (8, 4, 'BC-004-2', 'good', 'available'),
(9, 5, 'BC-005-1', 'good', 'available'), (10, 5, 'BC-005-2', 'good', 'available'),
(11, 6, 'BC-006-1', 'good', 'available'), (12, 6, 'BC-006-2', 'good', 'available'),
(13, 7, 'BC-007-1', 'good', 'available'), (14, 7, 'BC-007-2', 'good', 'available'),
(15, 8, 'BC-008-1', 'good', 'available'), (16, 8, 'BC-008-2', 'good', 'available'),
(17, 9, 'BC-009-1', 'good', 'available'), (18, 9, 'BC-009-2', 'good', 'available'),
(19, 10, 'BC-010-1', 'good', 'available'), (20, 10, 'BC-010-2', 'good', 'available'),
(21, 11, 'BC-011-1', 'good', 'available'), (22, 11, 'BC-011-2', 'good', 'available'),
(23, 12, 'BC-012-1', 'good', 'available'), (24, 12, 'BC-012-2', 'good', 'available'),
(25, 13, 'BC-013-1', 'good', 'available'), (26, 13, 'BC-013-2', 'good', 'available'),
(27, 14, 'BC-014-1', 'good', 'available'), (28, 14, 'BC-014-2', 'good', 'available'),
(29, 15, 'BC-015-1', 'good', 'available'), (30, 15, 'BC-015-2', 'good', 'available'),
(31, 16, 'BC-016-1', 'good', 'available'), (32, 16, 'BC-016-2', 'good', 'available'),
(33, 17, 'BC-017-1', 'good', 'available'), (34, 17, 'BC-017-2', 'good', 'available'),
(35, 18, 'BC-018-1', 'good', 'available'), (36, 18, 'BC-018-2', 'good', 'available'),
(37, 19, 'BC-019-1', 'good', 'available'), (38, 19, 'BC-019-2', 'good', 'available'),
(39, 20, 'BC-020-1', 'good', 'available'), (40, 20, 'BC-020-2', 'good', 'available'),
(41, 21, 'BC-021-1', 'good', 'available'), (42, 21, 'BC-021-2', 'good', 'available'),
(43, 22, 'BC-022-1', 'good', 'available'), (44, 22, 'BC-022-2', 'good', 'available'),
(45, 23, 'BC-023-1', 'good', 'available'), (46, 23, 'BC-023-2', 'good', 'available'),
(47, 24, 'BC-024-1', 'good', 'available'), (48, 24, 'BC-024-2', 'good', 'available'),
(49, 25, 'BC-025-1', 'good', 'available'), (50, 25, 'BC-025-2', 'good', 'available'),
(51, 26, 'BC-026-1', 'good', 'available'), (52, 26, 'BC-026-2', 'good', 'available'),
(53, 27, 'BC-027-1', 'good', 'available'), (54, 27, 'BC-027-2', 'good', 'available'),
(55, 28, 'BC-028-1', 'good', 'available'), (56, 28, 'BC-028-2', 'good', 'available'),
(57, 29, 'BC-029-1', 'good', 'available'), (58, 29, 'BC-029-2', 'good', 'available'),
(59, 30, 'BC-030-1', 'good', 'available'), (60, 30, 'BC-030-2', 'good', 'available'),
(61, 31, 'BC-031-1', 'good', 'available'), (62, 31, 'BC-031-2', 'good', 'available'),
(63, 32, 'BC-032-1', 'good', 'available'), (64, 32, 'BC-032-2', 'good', 'available'),
(65, 33, 'BC-033-1', 'good', 'available'), (66, 33, 'BC-033-2', 'good', 'available'),
(67, 34, 'BC-034-1', 'good', 'available'), (68, 34, 'BC-034-2', 'good', 'available'),
(69, 35, 'BC-035-1', 'good', 'available'), (70, 35, 'BC-035-2', 'good', 'available'),
(71, 36, 'BC-036-1', 'good', 'available'), (72, 36, 'BC-036-2', 'good', 'available'),
(73, 37, 'BC-037-1', 'good', 'available'), (74, 37, 'BC-037-2', 'good', 'available'),
(75, 38, 'BC-038-1', 'good', 'available'), (76, 38, 'BC-038-2', 'good', 'available'),
(77, 39, 'BC-039-1', 'good', 'available'), (78, 39, 'BC-039-2', 'good', 'available'),
(79, 40, 'BC-040-1', 'good', 'available'), (80, 40, 'BC-040-2', 'good', 'available'),
(81, 41, 'BC-041-1', 'good', 'available'), (82, 41, 'BC-041-2', 'good', 'available'),
(83, 42, 'BC-042-1', 'good', 'available'), (84, 42, 'BC-042-2', 'good', 'available'),
(85, 43, 'BC-043-1', 'good', 'available'), (86, 43, 'BC-043-2', 'good', 'available'),
(87, 44, 'BC-044-1', 'good', 'available'), (88, 44, 'BC-044-2', 'good', 'available'),
(89, 45, 'BC-045-1', 'good', 'available'), (90, 45, 'BC-045-2', 'good', 'available'),
-- Added Books copies (91-150)
(91, 46, 'BC-046-1', 'good', 'available'), (92, 46, 'BC-046-2', 'good', 'available'),
(93, 47, 'BC-047-1', 'good', 'available'), (94, 47, 'BC-047-2', 'good', 'available'),
(95, 48, 'BC-048-1', 'good', 'available'), (96, 48, 'BC-048-2', 'good', 'available'),
(97, 49, 'BC-049-1', 'good', 'available'), (98, 49, 'BC-049-2', 'good', 'available'),
(99, 50, 'BC-050-1', 'good', 'available'), (100, 50, 'BC-050-2', 'good', 'available'),
(101, 51, 'BC-051-1', 'good', 'available'), (102, 51, 'BC-051-2', 'good', 'available'),
(103, 52, 'BC-052-1', 'good', 'available'), (104, 52, 'BC-052-2', 'good', 'available'),
(105, 53, 'BC-053-1', 'good', 'available'), (106, 53, 'BC-053-2', 'good', 'available'),
(107, 54, 'BC-054-1', 'good', 'available'), (108, 54, 'BC-054-2', 'good', 'available'),
(109, 55, 'BC-055-1', 'good', 'available'), (110, 55, 'BC-055-2', 'good', 'available'),
(111, 56, 'BC-056-1', 'good', 'available'), (112, 56, 'BC-056-2', 'good', 'available'),
(113, 57, 'BC-057-1', 'good', 'available'), (114, 57, 'BC-057-2', 'good', 'available'),
(115, 58, 'BC-058-1', 'good', 'available'), (116, 58, 'BC-058-2', 'good', 'available'),
(117, 59, 'BC-059-1', 'good', 'available'), (118, 59, 'BC-059-2', 'good', 'available'),
(119, 60, 'BC-060-1', 'good', 'available'), (120, 60, 'BC-060-2', 'good', 'available'),
(121, 61, 'BC-061-1', 'good', 'available'), (122, 61, 'BC-061-2', 'good', 'available'),
(123, 62, 'BC-062-1', 'good', 'available'), (124, 62, 'BC-062-2', 'good', 'available'),
(125, 63, 'BC-063-1', 'good', 'available'), (126, 63, 'BC-063-2', 'good', 'available'),
(127, 64, 'BC-064-1', 'good', 'available'), (128, 64, 'BC-064-2', 'good', 'available'),
(129, 65, 'BC-065-1', 'good', 'available'), (130, 65, 'BC-065-2', 'good', 'available'),
(131, 66, 'BC-066-1', 'good', 'available'), (132, 66, 'BC-066-2', 'good', 'available'),
(133, 67, 'BC-067-1', 'good', 'available'), (134, 67, 'BC-067-2', 'good', 'available'),
(135, 68, 'BC-068-1', 'good', 'available'), (136, 68, 'BC-068-2', 'good', 'available'),
(137, 69, 'BC-069-1', 'good', 'available'), (138, 69, 'BC-069-2', 'good', 'available'),
(139, 70, 'BC-070-1', 'good', 'available'), (140, 70, 'BC-070-2', 'good', 'available'),
(141, 71, 'BC-071-1', 'good', 'available'), (142, 71, 'BC-071-2', 'good', 'available'),
(143, 72, 'BC-072-1', 'good', 'available'), (144, 72, 'BC-072-2', 'good', 'available'),
(145, 73, 'BC-073-1', 'good', 'available'), (146, 73, 'BC-073-2', 'good', 'available'),
(147, 74, 'BC-074-1', 'good', 'available'), (148, 74, 'BC-074-2', 'good', 'available'),
(149, 75, 'BC-075-1', 'good', 'available'), (150, 75, 'BC-075-2', 'good', 'available');
SET IDENTITY_INSERT BookCopy OFF;

-- ------------------------------------------------------------
-- 8. INSERT BORROW RECORDS (10 BORROW RECORDS PER USER, STRENGTHENED TENDENCIES)
-- ------------------------------------------------------------
SET IDENTITY_INSERT BorrowRecord ON;

-- User 86 (student1@lms.com): Tendency "Java Enterprise Backend & Cloud Native Developer"
INSERT INTO BorrowRecord (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, [status]) VALUES
(1, 86, 1, 1, DATEADD(day, -45, GETDATE()), DATEADD(day, -30, GETDATE()), DATEADD(day, -31, GETDATE()), 'returned'),
(2, 86, 3, 2, DATEADD(day, -40, GETDATE()), DATEADD(day, -25, GETDATE()), DATEADD(day, -26, GETDATE()), 'returned'),
(3, 86, 17, 9, DATEADD(day, -35, GETDATE()), DATEADD(day, -20, GETDATE()), DATEADD(day, -21, GETDATE()), 'returned'),
(4, 86, 19, 10, DATEADD(day, -30, GETDATE()), DATEADD(day, -15, GETDATE()), DATEADD(day, -16, GETDATE()), 'returned'),
(5, 86, 21, 11, DATEADD(day, -25, GETDATE()), DATEADD(day, -10, GETDATE()), DATEADD(day, -11, GETDATE()), 'returned'),
(6, 86, 23, 12, DATEADD(day, -20, GETDATE()), DATEADD(day, -5, GETDATE()), DATEADD(day, -6, GETDATE()), 'returned'),
(7, 86, 25, 13, DATEADD(day, -15, GETDATE()), DATEADD(day, -1, GETDATE()), DATEADD(day, -2, GETDATE()), 'returned'),
(8, 86, 33, 17, DATEADD(day, -10, GETDATE()), DATEADD(day, 5, GETDATE()), NULL, 'borrowed'),
(9, 86, 67, 34, DATEADD(day, -5, GETDATE()), DATEADD(day, 10, GETDATE()), NULL, 'borrowed'),
(10, 86, 69, 35, DATEADD(day, -2, GETDATE()), DATEADD(day, 13, GETDATE()), NULL, 'borrowed');

-- User 87 (student2@lms.com): Tendency "Modern Fullstack JavaScript Developer (Node, React, NoSQL)"
INSERT INTO BorrowRecord (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, [status]) VALUES
(11, 87, 49, 25, DATEADD(day, -45, GETDATE()), DATEADD(day, -30, GETDATE()), DATEADD(day, -31, GETDATE()), 'returned'),
(12, 87, 51, 26, DATEADD(day, -40, GETDATE()), DATEADD(day, -25, GETDATE()), DATEADD(day, -26, GETDATE()), 'returned'),
(13, 87, 53, 27, DATEADD(day, -35, GETDATE()), DATEADD(day, -20, GETDATE()), DATEADD(day, -21, GETDATE()), 'returned'),
(14, 87, 55, 28, DATEADD(day, -30, GETDATE()), DATEADD(day, -15, GETDATE()), DATEADD(day, -16, GETDATE()), 'returned'),
(15, 87, 57, 29, DATEADD(day, -25, GETDATE()), DATEADD(day, -10, GETDATE()), DATEADD(day, -11, GETDATE()), 'returned'),
(16, 87, 59, 30, DATEADD(day, -20, GETDATE()), DATEADD(day, -5, GETDATE()), DATEADD(day, -6, GETDATE()), 'returned'),
(17, 87, 61, 31, DATEADD(day, -15, GETDATE()), DATEADD(day, -1, GETDATE()), DATEADD(day, -2, GETDATE()), 'returned'),
(18, 87, 63, 32, DATEADD(day, -10, GETDATE()), DATEADD(day, 5, GETDATE()), NULL, 'borrowed'),
(19, 87, 37, 19, DATEADD(day, -5, GETDATE()), DATEADD(day, 10, GETDATE()), NULL, 'borrowed'),
(20, 87, 39, 20, DATEADD(day, -2, GETDATE()), DATEADD(day, 13, GETDATE()), NULL, 'borrowed');

-- User 88 (student3@lms.com): Tendency "AI/ML Engineer & Data Scientist (Python, ML, Data Analytics)"
INSERT INTO BorrowRecord (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, [status]) VALUES
(21, 88, 5, 3, DATEADD(day, -45, GETDATE()), DATEADD(day, -30, GETDATE()), DATEADD(day, -31, GETDATE()), 'returned'),
(22, 88, 7, 4, DATEADD(day, -40, GETDATE()), DATEADD(day, -25, GETDATE()), DATEADD(day, -26, GETDATE()), 'returned'),
(23, 88, 79, 40, DATEADD(day, -35, GETDATE()), DATEADD(day, -20, GETDATE()), DATEADD(day, -21, GETDATE()), 'returned'),
(24, 88, 81, 41, DATEADD(day, -30, GETDATE()), DATEADD(day, -15, GETDATE()), DATEADD(day, -16, GETDATE()), 'returned'),
(25, 88, 83, 42, DATEADD(day, -25, GETDATE()), DATEADD(day, -10, GETDATE()), DATEADD(day, -11, GETDATE()), 'returned'),
(26, 88, 85, 43, DATEADD(day, -20, GETDATE()), DATEADD(day, -5, GETDATE()), DATEADD(day, -6, GETDATE()), 'returned'),
(27, 88, 87, 44, DATEADD(day, -15, GETDATE()), DATEADD(day, -1, GETDATE()), DATEADD(day, -2, GETDATE()), 'returned'),
(28, 88, 89, 45, DATEADD(day, -10, GETDATE()), DATEADD(day, 5, GETDATE()), NULL, 'borrowed'),
(29, 88, 41, 21, DATEADD(day, -5, GETDATE()), DATEADD(day, 10, GETDATE()), NULL, 'borrowed'),
(30, 88, 43, 22, DATEADD(day, -2, GETDATE()), DATEADD(day, 13, GETDATE()), NULL, 'borrowed');

SET IDENTITY_INSERT BorrowRecord OFF;

