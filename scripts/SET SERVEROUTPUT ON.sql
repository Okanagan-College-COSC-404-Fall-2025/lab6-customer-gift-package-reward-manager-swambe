SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE cus_rew_join IS
BEGIN
    for cus IN (
        SELECT cr.customer_email, cr.REWARD_ID, cr.reward_date, gc.gifts
        FROM CUSTOMER_REWARDS cr
        JOIN GIFT_CATALOG gc ON cr.GIFT_ID = gc.GIFT_ID
        ORDER BY cr.REWARD_ID
        FETCH FIRST 5 ROWS ONLY
    )
    LOOP
        DBMS_OUTPUT.PUT('Reward ID: ' || cus.REWARD_ID || ' Customer Email: ' || cus.customer_email || ' Reward Date: ' || cus.reward_date || ' Gifts: {');
        FOR i IN 1 .. cus.Gifts.COUNT LOOP
            IF i = cus.Gifts.COUNT THEN
                DBMS_OUTPUT.PUT(cus.GIFTS(i) || '}');
            ELSE 
                DBMS_OUTPUT.PUT(cus.GIFTS(i) || ', ');
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END cus_rew_join;