-- ==========================================================================
-- LMS SEED DATA SEGMENT: 25 Catalog Books & BookCopies (Rich Tags 5-6 per book)
-- ==========================================================================

DO $$
DECLARE
    v_b1 INT; v_b2 INT; v_b3 INT; v_b4 INT; v_b5 INT;
    v_b6 INT; v_b7 INT; v_b8 INT; v_b9 INT; v_b10 INT;
    v_b11 INT; v_b12 INT; v_b13 INT; v_b14 INT; v_b15 INT;
    v_b16 INT; v_b17 INT; v_b18 INT; v_b19 INT; v_b20 INT;
    v_b21 INT; v_b22 INT; v_b23 INT; v_b24 INT; v_b25 INT;
BEGIN

    -- 1. Effective Java (3rd Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780134685991', 'Effective Java (3rd Edition)', 'Joshua Bloch', 'Addison-Wesley', 2018, 125000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b1;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b1, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b1, tagId FROM Tag WHERE name IN ('Textbook', 'Coding', 'Reference', 'OpenSource', 'Advanced');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b1, 'Kệ CS-5991-1', 'good', 'available', 'BC9780134685991-01'),
    (v_b1, 'Kệ CS-5991-2', 'good', 'available', 'BC9780134685991-02');


    -- 2. Clean Code
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780132350884', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 110000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b2;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b2, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b2, tagId FROM Tag WHERE name IN ('Textbook', 'Coding', 'Reference', 'Management', 'OpenSource');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b2, 'Kệ CS-0884-1', 'good', 'available', 'BC9780132350884-01'),
    (v_b2, 'Kệ CS-0884-2', 'good', 'available', 'BC9780132350884-02');


    -- 3. Design Patterns
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', 'Addison-Wesley', 1994, 135000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b3;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b3, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b3, tagId FROM Tag WHERE name IN ('Reference', 'Theoretical', 'Coding', 'Advanced', 'Modeling');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b3, 'Kệ CS-3610-1', 'good', 'available', 'BC9780201633610-01'),
    (v_b3, 'Kệ CS-3610-2', 'good', 'available', 'BC9780201633610-02');


    -- 4. Corporate Finance (12th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781119560821', 'Corporate Finance (12th Edition)', 'Stephen Ross, Randolph Westerfield, Jeffrey Jaffe', 'Wiley', 2019, 140000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b4;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b4, categoryId FROM Category WHERE name = 'Economics & Finance';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b4, tagId FROM Tag WHERE name IN ('Textbook', 'CaseStudy', 'Strategic', 'Auditing_Assessment', 'DataAnalysis');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b4, 'Kệ GEN-0821-1', 'good', 'available', 'BC9781119560821-01'),
    (v_b4, 'Kệ GEN-0821-2', 'good', 'available', 'BC9781119560821-02');


    -- 5. Algorithms (4th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780321356680', 'Algorithms (4th Edition)', 'Robert Sedgewick, Kevin Wayne', 'Addison-Wesley', 2011, 130000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b5;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b5, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b5, tagId FROM Tag WHERE name IN ('Textbook', 'Coding', 'Theoretical', 'Optimization', 'Exercises');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b5, 'Kệ CS-6680-1', 'good', 'available', 'BC9780321356680-01'),
    (v_b5, 'Kệ CS-6680-2', 'good', 'available', 'BC9780321356680-02');


    -- 6. Macroeconomics (9th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780073523323', 'Macroeconomics (9th Edition)', 'N. Gregory Mankiw', 'Worth Publishers', 2015, 115000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b6;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b6, categoryId FROM Category WHERE name = 'Economics & Finance';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b6, tagId FROM Tag WHERE name IN ('Textbook', 'Theoretical', 'PublicPolicy', 'Globalization', 'Statistical');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b6, 'Kệ GEN-3323-1', 'good', 'available', 'BC9780073523323-01'),
    (v_b6, 'Kệ GEN-3323-2', 'good', 'available', 'BC9780073523323-02');


    -- 7. Introduction to Politics
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780199232741', 'Introduction to Politics', 'Robert Garner, Peter Ferdinand, Stephanie Lawson', 'Oxford University Press', 2016, 85000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b7;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b7, categoryId FROM Category WHERE name = 'Politics & International Relations';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b7, tagId FROM Tag WHERE name IN ('Introduction', 'Textbook', 'PublicPolicy', 'Globalization', 'HistoryOf');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b7, 'Kệ GEN-2741-1', 'good', 'available', 'BC9780199232741-01'),
    (v_b7, 'Kệ GEN-2741-2', 'good', 'available', 'BC9780199232741-02');


    -- 8. Designing Data-Intensive Applications
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781449331818', 'Designing Data-Intensive Applications', 'Martin Kleppmann', 'O''Reilly Media', 2017, 145000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b8;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b8, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b8, tagId FROM Tag WHERE name IN ('Reference', 'Advanced', 'BigData', 'InformationSystems', 'OpenSource');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b8, 'Kệ CS-1818-1', 'good', 'available', 'BC9781449331818-01'),
    (v_b8, 'Kệ CS-1818-2', 'good', 'available', 'BC9781449331818-02');


    -- 9. Artificial Intelligence: A Modern Approach (3rd Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780132145374', 'Artificial Intelligence: A Modern Approach (3rd Edition)', 'Stuart Russell, Peter Norvig', 'Pearson', 2010, 150000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b9;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b9, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b9, tagId FROM Tag WHERE name IN ('Textbook', 'AI_Driven', 'Advanced', 'EmergingTech', 'FutureTrends', 'Coding');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b9, 'Kệ CS-5374-1', 'good', 'available', 'BC9780132145374-01'),
    (v_b9, 'Kệ CS-5374-2', 'good', 'available', 'BC9780132145374-02');


    -- 10. Introduction to Electrodynamics (4th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780321573513', 'Introduction to Electrodynamics (4th Edition)', 'David J. Griffiths', 'Pearson', 2012, 105000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b10;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b10, categoryId FROM Category WHERE name = 'Physics';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b10, tagId FROM Tag WHERE name IN ('Textbook', 'Theoretical', 'Introduction', 'Exercises', 'AppliedSciences');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b10, 'Kệ GEN-3513-1', 'good', 'available', 'BC9780321573513-01'),
    (v_b10, 'Kệ GEN-3513-2', 'good', 'available', 'BC9780321573513-02');


    -- 11. Campbell Biology (11th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780134093413', 'Campbell Biology (11th Edition)', 'Lisa A. Urry, Michael L. Cain', 'Pearson', 2016, 148000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b11;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b11, categoryId FROM Category WHERE name = 'Biology & Ecology';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b11, tagId FROM Tag WHERE name IN ('Textbook', 'Reference', 'ResearchMethodology', 'AppliedSciences', 'Experimental');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b11, 'Kệ GEN-93413-1', 'good', 'available', 'BC9780134093413-01'),
    (v_b11, 'Kệ GEN-93413-2', 'good', 'available', 'BC9780134093413-02');


    -- 12. Introduction to Physics (9th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780470503201', 'Introduction to Physics (9th Edition)', 'John D. Cutnell, Kenneth W. Johnson', 'Wiley', 2012, 95000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b12;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b12, categoryId FROM Category WHERE name = 'Physics';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b12, tagId FROM Tag WHERE name IN ('Introduction', 'Textbook', 'Exercises', 'Theoretical', 'AppliedSciences');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b12, 'Kệ GEN-3201-1', 'good', 'available', 'BC9780470503201-01'),
    (v_b12, 'Kệ GEN-3201-2', 'good', 'available', 'BC9780470503201-02');


    -- 13. Organic Chemistry (9th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780078021558', 'Organic Chemistry (9th Edition)', 'Francis Carey, Robert Giuliano', 'McGraw-Hill Education', 2013, 138000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b13;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b13, categoryId FROM Category WHERE name = 'Chemistry';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b13, tagId FROM Tag WHERE name IN ('Textbook', 'Experimental', 'LabManual', 'AppliedSciences', 'Exercises');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b13, 'Kệ GEN-1558-1', 'good', 'available', 'BC9780078021558-01'),
    (v_b13, 'Kệ GEN-1558-2', 'good', 'available', 'BC9780078021558-02');


    -- 14. Microbiology: An Introduction (10th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780136006633', 'Microbiology: An Introduction (10th Edition)', 'Gerard J. Tortora, Berdell R. Funke', 'Pearson', 2009, 142000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b14;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b14, categoryId FROM Category WHERE name IN ('Biology & Ecology', 'Medicine & Health Sciences');
    INSERT INTO BookTag (bookId, tagId) SELECT v_b14, tagId FROM Tag WHERE name IN ('Textbook', 'LabManual', 'Experimental', 'ResearchMethodology', 'AppliedSciences');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b14, 'Kệ GEN-6633-1', 'good', 'available', 'BC9780136006633-01'),
    (v_b14, 'Kệ GEN-6633-2', 'good', 'available', 'BC9780136006633-02');


    -- 15. Principles of Anatomy and Physiology (13th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780470646151', 'Principles of Anatomy and Physiology (13th Edition)', 'Gerard J. Tortora, Bryan H. Derrickson', 'Wiley', 2011, 150000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b15;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b15, categoryId FROM Category WHERE name = 'Medicine & Health Sciences';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b15, tagId FROM Tag WHERE name IN ('Textbook', 'Reference', 'AppliedSciences', 'Behavioral', 'LabManual');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b15, 'Kệ GEN-6151-1', 'good', 'available', 'BC9780470646151-01'),
    (v_b15, 'Kệ GEN-6151-2', 'good', 'available', 'BC9780470646151-02');


    -- 16. Introduction to Business (5th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781285057903', 'Introduction to Business (5th Edition)', 'Jeff Madura', 'Cengage Learning', 2013, 75000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b16;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b16, categoryId FROM Category WHERE name = 'Business Administration';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b16, tagId FROM Tag WHERE name IN ('Introduction', 'Textbook', 'Management', 'Startup', 'Strategic');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b16, 'Kệ GEN-7903-1', 'good', 'available', 'BC9781285057903-01'),
    (v_b16, 'Kệ GEN-7903-2', 'good', 'available', 'BC9781285057903-02');


    -- 17. Marketing Management (15th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780133098754', 'Marketing Management (15th Edition)', 'Philip Kotler, Kevin Lane Keller', 'Pearson', 2015, 120000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b17;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b17, categoryId FROM Category WHERE name = 'Business Administration';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b17, tagId FROM Tag WHERE name IN ('Textbook', 'CaseStudy', 'Strategic', 'DigitalTransformation', 'Behavioral');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b17, 'Kệ GEN-8754-1', 'good', 'available', 'BC9780133098754-01'),
    (v_b17, 'Kệ GEN-8754-2', 'good', 'available', 'BC9780133098754-02');


    -- 18. General, Organic, and Biological Chemistry
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781133312789', 'General, Organic, and Biological Chemistry', 'H. Stephen Stoker', 'Cengage Learning', 2015, 118000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b18;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b18, categoryId FROM Category WHERE name IN ('Chemistry', 'Pharmacy & Biochemistry');
    INSERT INTO BookTag (bookId, tagId) SELECT v_b18, tagId FROM Tag WHERE name IN ('Textbook', 'LabManual', 'Experimental', 'AppliedSciences', 'Exercises');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b18, 'Kệ GEN-2789-1', 'good', 'available', 'BC9781133312789-01'),
    (v_b18, 'Kệ GEN-2789-2', 'good', 'available', 'BC9781133312789-02');


    -- 19. Introduction to Law
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780199571123', 'Introduction to Law', 'Jaap Hage, Bram Akkermans', 'Springer', 2014, 88000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b19;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b19, categoryId FROM Category WHERE name = 'Law & Legal Studies';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b19, tagId FROM Tag WHERE name IN ('Introduction', 'Textbook', 'Regulations', 'Ethics', 'PublicPolicy');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b19, 'Kệ GEN-1123-1', 'good', 'available', 'BC9780199571123-01'),
    (v_b19, 'Kệ GEN-1123-2', 'good', 'available', 'BC9780199571123-02');


    -- 20. Principles of Psychology
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781305073036', 'Principles of Psychology', 'S. Marc Breedlove', 'Oxford University Press', 2015, 98000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b20;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b20, categoryId FROM Category WHERE name = 'Psychology';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b20, tagId FROM Tag WHERE name IN ('Textbook', 'Behavioral', 'ResearchMethodology', 'Experimental', 'CaseStudy');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b20, 'Kệ GEN-3036-1', 'good', 'available', 'BC9781305073036-01'),
    (v_b20, 'Kệ GEN-3036-2', 'good', 'available', 'BC9781305073036-02');


    -- 21. Designing the User Interface (6th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780321838964', 'Designing the User Interface (6th Edition)', 'Ben Shneiderman, Catherine Plaisant', 'Pearson', 2016, 128000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b21;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b21, categoryId FROM Category WHERE name IN ('Computer Science', 'Arts & Design');
    INSERT INTO BookTag (bookId, tagId) SELECT v_b21, tagId FROM Tag WHERE name IN ('Reference', 'Visual_Design', 'Behavioral', 'DigitalTransformation', 'Coding');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b21, 'Kệ CS-8964-1', 'good', 'available', 'BC9780321838964-01'),
    (v_b21, 'Kệ CS-8964-2', 'good', 'available', 'BC9780321838964-02');


    -- 22. Software Engineering (10th Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780133914641', 'Software Engineering (10th Edition)', 'Ian Sommerville', 'Pearson', 2015, 132000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b22;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b22, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b22, tagId FROM Tag WHERE name IN ('Textbook', 'Management', 'Strategic', 'ResearchMethodology', 'OpenSource');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b22, 'Kệ CS-4641-1', 'good', 'available', 'BC9780133914641-01'),
    (v_b22, 'Kệ CS-4641-2', 'good', 'available', 'BC9780133914641-02');


    -- 23. Kafka: The Definitive Guide
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781491950296', 'Kafka: The Definitive Guide', 'Neha Narkhede, Gwen Shapira, Todd Palino', 'O''Reilly Media', 2017, 92000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b23;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b23, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b23, tagId FROM Tag WHERE name IN ('Reference', 'Advanced', 'BigData', 'InformationSystems', 'Coding');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b23, 'Kệ CS-0296-1', 'good', 'available', 'BC9781491950296-01'),
    (v_b23, 'Kệ CS-0296-2', 'good', 'available', 'BC9781491950296-02');


    -- 24. Soft Skills: The software developer's life manual
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9781501257285', 'Soft Skills: The software developer''s life manual', 'John Sonmez', 'Manning Publications', 2014, 65000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b24;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b24, categoryId FROM Category WHERE name = 'Soft Skills';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b24, tagId FROM Tag WHERE name IN ('Reference', 'Management', 'Behavioral', 'Startup', 'Ethics');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b24, 'Kệ GEN-7285-1', 'good', 'available', 'BC9781501257285-01'),
    (v_b24, 'Kệ GEN-7285-2', 'good', 'available', 'BC9781501257285-02');


    -- 25. Introduction to Algorithms (3rd Edition)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status)
    VALUES ('9780073523859', 'Introduction to Algorithms (3rd Edition)', 'Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein', 'MIT Press', 2009, 145000.00, 2, 2, 'available')
    RETURNING bookId INTO v_b25;

    INSERT INTO BookCategory (bookId, categoryId) SELECT v_b25, categoryId FROM Category WHERE name = 'Computer Science';
    INSERT INTO BookTag (bookId, tagId) SELECT v_b25, tagId FROM Tag WHERE name IN ('Textbook', 'Theoretical', 'Advanced', 'Coding', 'Optimization', 'Exercises');
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES
    (v_b25, 'Kệ CS-3859-1', 'good', 'available', 'BC9780073523859-01'),
    (v_b25, 'Kệ CS-3859-2', 'good', 'available', 'BC9780073523859-02');

END $$;
