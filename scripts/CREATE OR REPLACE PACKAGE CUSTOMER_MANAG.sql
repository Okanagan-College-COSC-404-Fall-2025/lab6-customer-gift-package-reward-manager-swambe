CREATE OR REPLACE PACKAGE CUSTOMER_MANAGER IS
    FUNCTION GET_TOTAL_PURCHASE(p_customer_id IN NUMBER) RETURN NUMBER;
    PROCEDURE ASSIGN_GIFTS_TO_ALL;
END CUSTOMER_MANAGER;

CREATE OR REPLACE PACKAGE BODY CUSTOMER_MANAGER AS
    FUNCTION GET_TOTAL_PURCHASE(p_customer_id IN NUMBER) 
    RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(oi.unit_price * oi.quantity), 0)
        INTO v_total
        FROM ORDERS o
        JOIN ORDER_ITEMS oi ON o.ORDER_ID = oi.ORDER_ID
        WHERE o.CUSTOMER_ID = p_customer_id;
    RETURN v_total;
    END GET_TOTAL_PURCHASE;

    FUNCTION CHOOSE_GIFT_PACKAGE(p_total_purchase in NUMBER) 
    RETURN NUMBER IS
        v_gift_id NUMBER;
        BEGIN 
        v_gift_id := CASE 
            WHEN p_total_purchase > 10000 THEN 3
            WHEN p_total_purchase > 1000 THEN 2
            WHEN p_total_purchase > 100 THEN 1
            ELSE NULL
            END;
        RETURN v_gift_id;
    END CHOOSE_GIFT_PACKAGE;

    PROCEDURE ASSIGN_GIFTS_TO_ALL IS
        v_gift_id NUMBER;
    BEGIN
        FOR cus IN (
            SELECT c.customer_id, c.EMAIL_ADDRESS FROM CUSTOMERS c
        )
        LOOP
            v_gift_id := CHOOSE_GIFT_PACKAGE(GET_TOTAL_PURCHASE(cus.customer_id));
            INSERT INTO CUSTOMER_REWARDS (CUSTOMER_EMAIL, GIFT_ID, REWARD_DATE) 
            VALUES (cus.email_address, v_gift_id, SYSDATE);
        END LOOP;
    END;
        
END CUSTOMER_MANAGER;