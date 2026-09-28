*增强示例代码
IF sy-tcode = 'CO01' OR sy-tcode = 'XXXXXX' 
  IF caufvd_imp-werks IS NOT INITIAL AND caufvd_imp-matnr IS NOT INITIAL.
    SELECT SINGLE feh_sta INTO @DATA(lv_feh_sta)
       FROM  keko
      WHERE matnr = @caufvd_imp-matnr
       AND feh_sta = 'FR'
       AND werks = @caufvd_imp-werks.
    IF sy-subrc <> 0.
      MESSAGE e000(zpp01) WITH '此产品还没有进行标准成本估算'.
    ENDIF.

    "工单创建时检查成品标准成本增强
    SELECT SINGLE bwkey INTO @DATA(l_bwkey)
      FROM t001w
     WHERE werks = @caufvd_imp-werks.
    SELECT SINGLE lplpr INTO @DATA(l_lplpr)
      FROM mbew
     WHERE matnr = @caufvd_imp-matnr
       AND bwkey = @l_bwkey.
    IF l_lplpr IS INITIAL.
      MESSAGE e001(00) WITH '此产品还没有标准成本价格'.
    ENDIF.

    SELECT * FROM makz INTO TABLE @DATA(lt_makz)
     WHERE werks = @caufvd_imp-werks
       AND matnr = @caufvd_imp-matnr.

    IF NOT lt_makz IS INITIAL.
      SELECT matnr,lplpr
        FROM mbew
         FOR ALL ENTRIES IN @lt_makz
       WHERE matnr = @lt_makz-kuppl
         AND bwkey = @l_bwkey
        INTO TABLE @DATA(lt_mbew).
      SORT lt_mbew BY matnr.
      LOOP AT lt_makz INTO DATA(ls_makz).
        READ TABLE lt_mbew INTO DATA(ls_mbew) WITH KEY matnr = ls_makz-kuppl BINARY SEARCH.
        IF ls_mbew-lplpr IS INITIAL.
          DATA(l_messg) = ls_makz-kuppl.
          SHIFT l_messg LEFT DELETING LEADING '0'.
          MESSAGE e001(00) WITH '联产品:' l_messg '还没有标准成本价格'.
        ENDIF.
        CLEAR ls_mbew.
      ENDLOOP.

    ENDIF.
  ENDIF.
ENDIF.
