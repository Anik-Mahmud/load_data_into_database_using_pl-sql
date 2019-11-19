GRANT EXECUTE ON UTL_FILE TO PUBLIC;

create or replace directory IMPORTDIR as 'C:\Users\Anik\Documents\pl_sql\pl_load';
grant read, write on directory IMPORTDIR to scott;



CREATE or REPLACE PROCEDURE LoadLecturerData(p_FileDir in varchar2,p_fileName in varchar2)
AS
    v_FileHandle UTL_FILE.FILE_TYPE;
    v_newLine VARCHAR2(100);
    MyFirstName lecturer.first_name%TYPE;
    v_LastName lecturer.last_name%TYPE;
    v_major lecturer.major%TYPE;
    v_FirstComma NUMBER;
    v_SecondComma NUMBER;
    p_TotalInserted NUMBER;
    
BEGIN
    v_FileHandle :=UTL_FILE.FOPEN(p_FileDir ,p_FileName,'r');
    p_TotalInserted :=1;
    LOOP
        BEGIN
        UTL_FILE.GET_LINE(v_FileHandle, v_NewLine);
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        EXIT;
        END;
        
        v_FirstComma :=INSTR(v_NewLine,',',1,1);
        v_SecondComma :=INSTR(v_NewLine,',',1,2);
        
        MyFirstName :=SUBSTR(v_NewLine, 1, v_FirstComma -1);
        v_LastName :=SUBSTR(v_NewLine, v_FirstComma+1, v_secondComma - v_FirstComma -1);
        v_Major :=SUBSTR(v_NewLine, v_SecondComma + 1);
        INSERT INTO lecturer(ID,First_name,last_name,major)VALUES(p_TotalInserted,TO_CHAR(MyFirstName), TO_CHAR(v_LastName),TO_CHAR(v_major));
        p_TotalInserted :=p_TotalInserted + 1;
        END LOOP;
        UTL_FILE.FCLOSE(v_FileHandle);
        COMMIT;
   
   EXCEPTION
   WHEN UTL_FILE.INVALID_OPERATION THEN
        UTL_FILE.FCLOSE(v_FileHandle);
        RAISE_APPLICATION_ERROR(-20051,'LoadLectuerData: Invalid Operation');
    WHEN OTHERS THEN
        UTL_FILE.FCLOSE(v_FileHandle);
        RAISE;
        
END LoadLecturerData;
/   

create or replace directory IMPORTDIR as 'C:\Users\Anik\Documents\pl_sql\pl_load';
grant read, write on directory IMPORTDIR to scott;
BEGIN
LoadLecturerData('IMPORTDIR','LECTURER_DATA.csv');
END;




SELECT
    *
FROM lecturer;