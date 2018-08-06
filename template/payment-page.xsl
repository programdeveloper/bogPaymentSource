<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="no" method="html"/>

    <!--Variable definition-->
    <xsl:variable name="RESOURCE_BASE" select="/payment-page/@resources-base-url"/>
    <xsl:variable name="LANG" select="/payment-page/@language-code"/>
    <xsl:variable name="MERCHANT_ID" select="/payment-page/merchant/@pcid"/>
    <xsl:variable name="MERCHANT_TITLE" select="/payment-page/merchant/@title"/>
    <xsl:variable name="MERCHANT_URL" select="/payment-page/merchant/@url"/>

    <xsl:variable name="PAYMENT_DESCRIPTION" select="/payment-page/purchase/@desc"/>
    <xsl:variable name="HIDE_DESC" select="/payment-page/payment-params/payment-param[@id='hidedesc']/@value"/>
    <xsl:variable name="AMOUNT" select="/payment-page/payment-details/@amount"/>
    <xsl:variable name="PAYMENT_AMOUNT" select="/payment-page/payment-details/@display-amount"/>

    <xsl:variable name="CARD_TYPE_PARAM" select="string('p.type')"/>
    <xsl:variable name="PAN_PARAM" select="string('p.pan')"/>
    <xsl:variable name="EXPIRY_PARAM" select="string('p.expiry')"/>
    <xsl:variable name="CARDHOLDER_PARAM" select="string('p.cardholder')"/>
    <xsl:variable name="CVV2_PARAM" select="string('p.cvv2')"/>
    <xsl:variable name="PAY_BONUS_PARAM" select="string('paybonus')"/>
    <xsl:variable name="PAY_BONUS_BIN_RANGES_PARAM" select="string('paybonusbinranges')"/>
    <xsl:variable name="PAY_BONUS_RATE_OFFER" select="/payment-page/payment-params/payment-param[@id='paybonusexchangerate']/@value"/>
    <xsl:variable name="PAY_BONUS_RATE" select="/payment-page/payment-details/@paybonus-exchange-rate"/>

    <xsl:variable name="SHOW_CARDHOLDER" select="string('no')"/>
    <xsl:variable name="SHOW_EMAIL" select="string('no')"/>
    <xsl:variable name="WITH_REDIRECT" select="string('yes')"/>

    <!--System template-->
    <xsl:template match="payment-page">
        <xsl:choose>
            <xsl:when test="payment-params">
                <xsl:call-template name="INPUT_PARAMS">
                    <xsl:with-param name="ACTION_URL" select="/payment-page/payment-params/@action"/>
                    <xsl:with-param name="ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@error='true']">error</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="CARD_TYPE" select="/payment-page/payment-params/payment-param[@id=$CARD_TYPE_PARAM]"/>
                    <xsl:with-param name="CARD_TYPE_VALUE" select="/payment-page/payment-params/payment-param[@id=$CARD_TYPE_PARAM]/@value"/>
                    <xsl:with-param name="CARD_TYPE_ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$CARD_TYPE_PARAM]/@error='true'">error</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="PAN" select="/payment-page/payment-params/payment-param[@id=$PAN_PARAM]"/>
                    <xsl:with-param name="PAN_VALUE" select="/payment-page/payment-params/payment-param[@id=$PAN_PARAM]/@value"/>
                    <xsl:with-param name="PAN_ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$PAN_PARAM]/@error='true'">error</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="PAN_MASKED">
                        <xsl:if test="contains(/payment-page/payment-params/payment-param[@id=$PAN_PARAM]/@value, 'x')">true</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="CARDHOLDER" select="/payment-page/payment-params/payment-param[@id=$CARDHOLDER_PARAM]"/>
                    <xsl:with-param name="CARDHOLDER_VALUE" select="/payment-page/payment-params/payment-param[@id=$CARDHOLDER_PARAM]/@value"/>
                    <xsl:with-param name="CARDHOLDER_ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$CARDHOLDER_PARAM]/@error='true'">error</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="CVV2" select="/payment-page/payment-params/payment-param[@id=$CVV2_PARAM]"/>
                    <xsl:with-param name="CVV2_VALUE" select="/payment-page/payment-params/payment-param[@id=$CVV2_PARAM]/@value"/>
                    <xsl:with-param name="CVV2_ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$CVV2_PARAM]/@error='true'">error</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="EXPIRY" select="/payment-page/payment-params/payment-param[@id=$EXPIRY_PARAM]"/>
                    <xsl:with-param name="EXPIRY_VALUE" select="/payment-page/payment-params/payment-param[@id=$EXPIRY_PARAM]/@value"/>
                    <xsl:with-param name="EXPIRY_ERROR">
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$EXPIRY_PARAM]/@error='true'">error</xsl:if>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="pareq"><xsl:call-template name="PROCESS_PAREQ"/></xsl:when>
            <xsl:when test="wait-please">
                <xsl:call-template name="WAIT_PLEASE">
                    <xsl:with-param name="REFRESH_URL" select="/payment-page/wait-please/@refresh-url"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="payment-result">
                <xsl:call-template name="PAYMENT_RESULT">
                    <xsl:with-param name="MERCHANT_BACK_URL" select="/payment-page/payment-result/@back-url"/>
                    <xsl:with-param name="DATE" select="/payment-page/payment-details/@payment-date"/>
                    <xsl:with-param name="TRX_ID" select="/payment-page/payment-details/@transaction-id"/>
                    <xsl:with-param name="CARD_TYPE" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.CARD_TYPE']/@value"/>
                    <xsl:with-param name="CARDHOLDER" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.CARDHOLDER']/@value"/>
                    <xsl:with-param name="PAN" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.MASKED_PAN']/@value"/>
                    <xsl:with-param name="EXPIRY" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.EXPIRY']/@value"/>
                    <xsl:with-param name="RESULT">
                        <xsl:choose>
                            <xsl:when test="/payment-page/payment-result/@result-code='0' and /payment-page/payment-result/@trx-extended-code='0'">COMPLETE_ONLINE</xsl:when>
                            <xsl:when test="/payment-page/payment-result/@result-code='0' and /payment-page/payment-result/@trx-extended-code='1'">COMPLETE_OFFLINE</xsl:when>
                            <xsl:when test="/payment-page/payment-result/@result-code='0' and /payment-page/payment-result/@trx-extended-code!='0' and /payment-page/payment-result/@trx-extended-code!='1'">COMPLETE_ONLINE</xsl:when>
                            <xsl:when test="/payment-page/payment-result/@result-code='1' and /payment-page/payment-result/@trx-extended-code='54'">USER_CANCELLED</xsl:when>
                            <xsl:otherwise>ERROR</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="RESULT_CODE" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.RESULT_CODE']/@value"/>
                    <xsl:with-param name="RESPONSE_CODE" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.RESPONSE_CODE']/@value"/>
                    <xsl:with-param name="REFERENCE_NUMBER" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.REFERENCE_NUMBER']/@value"/>
                    <xsl:with-param name="EMAIL_SENT" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.EMAIL_SENT']/@value"/>
                    <xsl:with-param name="EMAIL" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.EMAIL']/@value"/>
                    <xsl:with-param name="EMAIL_CHECK" select="/payment-page/payment-result/payment-schema-result/param[@name='CardPaymentSchema.EMAIL_CHECK']/@value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="page-expired">
                <xsl:call-template name="PAGE_EXPIRED">
                    <xsl:with-param name="CONTINUE_URL" select="/payment-page/page-expired/@continue-url"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="PAREQ_FORM">
        <form name="pareqForm" action="{/payment-page/pareq/@action-url}" method="POST">
            <input type="hidden" name="PaReq" value="{/payment-page/pareq/@pareq}"/>
            <input type="hidden" name="TermUrl" value="{/payment-page/pareq/@term-url}"/>
            <input type="hidden" name="MD" value="{/payment-page/pareq/@md}"/>
            <input type="hidden" name="aa" value="aa"/>
        </form>
        <script>document.pareqForm.submit();</script>
    </xsl:template>

    <!--reqired user templates-->
    <xsl:template name="INPUT_PARAMS">
        <!--Variables-->
        <xsl:param name="ACTION_URL"/>
        <xsl:param name="ERROR"/>
        <xsl:param name="CARD_TYPE"/>
        <xsl:param name="CARD_TYPE_VALUE"/>
        <xsl:param name="CARD_TYPE_ERROR"/>
        <xsl:param name="PAN"/>
        <xsl:param name="PAN_VALUE"/>
        <xsl:param name="PAN_MASKED"/>
        <xsl:param name="PAN_ERROR"/>
        <xsl:param name="CARDHOLDER"/>
        <xsl:param name="CARDHOLDER_VALUE"/>
        <xsl:param name="CARDHOLDER_ERROR"/>
        <xsl:param name="CVV2"/>
        <xsl:param name="CVV2_VALUE"/>
        <xsl:param name="CVV2_ERROR"/>
        <xsl:param name="EXPIRY"/>
        <xsl:param name="EXPIRY_VALUE"/>
        <xsl:param name="EXPIRY_ERROR"/>

        <!--Template-->
        <xsl:call-template name="page-template">
            <xsl:with-param name="title">@INPUT_PARAMS_TITLE@</xsl:with-param>
            <xsl:with-param name="content">
                <script>
                    function chengeCVVDesc(num) {
                    $el_cvv_desc = $('.cvc-info');
                    if (num==4) {
                    $el_cvv_desc.html('@ABOUT_CSC@');
                    }
                    else {
                    $el_cvv_desc.html('@ABOUT_CVV@');
                    }
                    }
                </script>

                <xsl:if test="$ERROR='error'"><div class="formerror"><span class='red'>@INPUT_PARAMS_ERROR_WARNING@</span></div></xsl:if>
                <div id="offer">
                    <form id="payment-form" name="p.params" action="{$ACTION_URL}" method="POST" autocomplete="off">
                        <div class="card">
                            <div class="card-front">
                                <div class="input-group">
                                    <div id="brand-logo" class="brand-logo"></div>
                                    <span id="pan-input" class="form-input">
                                        <input id="pan_full" type="hidden" name="{$PAN_PARAM}" value="{$PAN_VALUE}"/>
                                        <label for="pan" class="placeholder">@PAN@</label>
                                        <xsl:choose>
                                            <xsl:when test="$PAN_MASKED='true'">
                                                <input id="pan_masked" name="" class=""
                                                       value="{$PAN_VALUE}" autocomplete="off"
                                                       required="required"
                                                       tabindex="1"
                                                       aria-required="true"
                                                       readonly="readonly"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <input id="pan" name="src.pan" class=""
                                                       value="{$PAN_VALUE}" autocomplete="off"
                                                       required="required" data-rule-pan="true" data-rule-minlength="18"
                                                       data-msg-required="@ERROR_REQUIRED@"
                                                       data-msg-pan="@ERROR_INC_PAN@"
                                                       data-msg-minlength="@ERROR_MINLENGTH_15@"
                                                       tabindex="1"
                                                       maxlength="23" aria-required="true"/>
                                                <span class="error-container"></span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </span>
                                </div>


                                <div class="input-group" id="expiry">
                                    <input type="hidden" name="p.expiry" value="{$EXPIRY_VALUE}"/>
                                    <label class="placeholder">@EXPIRY_DATE@ (@MONTH@ / @YEAR@)</label>
                                    <span id="month-input" class="form-input">
                                        <xsl:choose>
                                            <xsl:when test="$PAN_MASKED='true'">
                                                <input id="month" name="p.expiry.month" maxlength="2"
                                                       required="required"
                                                       value="{substring($EXPIRY_VALUE,3,2)}"
                                                       tabindex="2"
                                                       readonly="readonly"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <input id="month" name="p.expiry.month" maxlength="2"
                                                       required="required" data-rule-min="1" data-rule-max="12" data-rule-minlength="2"
                                                       data-msg="@ERROR_MONTH@"
                                                       data-msg-minlength="@ERROR_MINLENGTH_2@"
                                                       data-msg-required="@ERROR_REQUIRED@"
                                                       data-next-elem="year"
                                                       value="{substring($EXPIRY_VALUE,3,2)}"
                                                       tabindex="2"/>
                                                <span class="error-container" ></span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </span>
                                    <span class="slash">/</span>
                                    <span id="year-input" class="form-input">
                                        <xsl:choose>
                                            <xsl:when test="$PAN_MASKED='true'">
                                                <input id="year" name="p.expiry.year" maxlength="2" class=""
                                                       required="required"
                                                       value="{substring($EXPIRY_VALUE,1,2)}"
                                                       tabindex="3"
                                                       readonly="readonly"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <input id="year" name="p.expiry.year" maxlength="2" class=""
                                                       required="required" data-rule-min="17" data-rule-minlength="2"
                                                       data-msg="@ERROR_EXPIRED@"
                                                       data-msg-minlength="@ERROR_MINLENGTH_2@"
                                                       data-msg-required="@ERROR_REQUIRED@"
                                                       data-next-elem="cvc"
                                                       value="{substring($EXPIRY_VALUE,1,2)}"
                                                       tabindex="3"/>
                                                <span class="error-container"></span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </span>
                                </div>

                                <div class="input-group" id="cvv">
                                    <div class="cvc">
                                        <span id="cvc-input" class="form-input cvc-hint">
                                            <label for="cvc" class="placeholder">CVC2 ან CVV2: <i class="far fa-question-circle"></i></label>
                                            <input id="cvc" name="{$CVV2_PARAM}" maxlength="3" type="text" class=""
                                                   required="required"
                                                   data-rule-minlength="3"
                                                   data-msg-minlength1="@ERROR_MINLENGTH_TEXT_1@"
                                                   data-msg-minlength2="@ERROR_MINLENGTH_TEXT_2@"
                                                   data-msg-required="@ERROR_REQUIRED@"
                                                   data-next-elem="name"
                                                   value="{$CVV2_VALUE}"
                                                   tabindex="4"/>
                                            <span class="error-container"></span>
                                        </span>
                                        <div class="cvc-hover">
                                            <label class="cvc-info">@ABOUT_CVV@</label>
                                            <div class="cvc-info-image"></div>
                                        </div>
                                    </div>
                                </div>
                                <xsl:if test="$SHOW_CARDHOLDER = 'yes'">
                                    <div class="input-group" id="cardholder">
                                        <label class="input-label">@CARDHOLDER@</label>
                                        <span id="cardholdername-input" class="form-input">
                                            <label for="name" class="placeholder">@CARDHOLDER@</label>
                                            <xsl:choose>
                                                <xsl:when test="$PAN_MASKED='true'">
                                                    <input  id="name" name="{$CARDHOLDER_PARAM}" maxlength="24"
                                                            value="{$CARDHOLDER_VALUE}"
                                                            tabindex="5"
                                                            readonly="readonly"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <input  id="name" name="{$CARDHOLDER_PARAM}" maxlength="24"
                                                            class=""
                                                            required="required"
                                                            data-msg-required="@ERROR_REQUIRED@"
                                                            data-msg-chars="@ERROR_LATIN_CHARS_ONLY@"
                                                            value="{$CARDHOLDER_VALUE}"
                                                            tabindex="5"/>
                                                    <span class="error-container"></span>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </span>
                                    </div>
                                </xsl:if>
                                <xsl:if test="$SHOW_CARDHOLDER = 'no'">
                                    <style>
                                        <![CDATA[
                                            #cardholder {display: none;}
                                            #expiry {padding-top: 20px;}
                                            #cvv {padding-top: 20px;}
                                            ]]>
                                    </style>
                                </xsl:if>
                            </div>

                        </div>
                        <xsl:if test="/payment-page/payment-params/payment-param[@id=$PAY_BONUS_PARAM]/@value = 'Y'">
                            <div id="pay-bonus-wrapper">
                                <input type="hidden" name="p.paybonus" value="N"/>
                                <input type="checkbox" id="payBonusPoints"/><label for="payBonusPoints">@PAY_BONUS@</label>

                            </div>
                               <script>
                                <![CDATA[var payBonusBinRanges = "]]><xsl:value-of select="/payment-page/payment-params/payment-param[@id=$PAY_BONUS_BIN_RANGES_PARAM]/@value"/><![CDATA[";]]>
                                <![CDATA[
                                    function listen(evnt, elem, func) {
                                         if (elem.addEventListener)  // W3C DOM
                                              elem.addEventListener(evnt, func, false);
                                         else if (elem.attachEvent) { // IE DOM
                                              var r = elem.attachEvent("on" + evnt, func);
                                              return r;
                                         }
                                    }

                                    listen("load", window, function () {
                                        detectBonus();

                                       listen("keyup", document.getElementsByName("src.pan")[0], function() {
                                            detectBonus();
                                       });
                                       listen("input", document.getElementsByName("src.pan")[0], function() {
                                            detectBonus();
                                       });

                                       listen("click", document.getElementById("payBonusPoints"), function() {
                                             document.getElementsByName("p.paybonus")[0].value = this.checked ? "Y" : "N";
                                             if (this.checked == true) {
                                                $("#pay-bonus-msg-wrapper").show(300);
                                            } else {
                                                $("#pay-bonus-msg-wrapper").hide(200);
                                            }
                                       });
                                     });


                                    function detectBonus() {
                                        var pan = document.getElementsByName("src.pan")[0].value.replace(/[^0-9]/g, '');
                                            if(pan && validatePan(pan) &&  checkBonusBinRanges(pan)) {
                                                //document.getElementById("pay-bonus-wrapper").style.display = "block";
                                                $("#pay-bonus-wrapper").show(300);
                                            } else {
                                                  //document.getElementById("pay-bonus-wrapper").style.display = "none";
                                                  $("#pay-bonus-wrapper").hide(200);
                                                  $("#pay-bonus-wrapper").hide();
                                            }
                                    }

                                    function checkBonusBinRanges(value) {
                                        var isValid = false;
                                        var arrBinRanges = payBonusBinRanges.split(";");
                                        for(var i=0; i<arrBinRanges.length; i++) {
                                            var range = arrBinRanges[i].split("-");
                                            var valueForEqual = parseInt(value.substring(0, range[0].length));
                                            if(valueForEqual >= +range[0] && valueForEqual <= +range[1]) {
                                                isValid = true;
                                                break;
                                             }
                                        }
                                        return isValid;
                                    }

                                    function validatePan(value) {
                                        var min = 13, max = 19, b, c, d, e;
                                        for (d = +value[b = value.length - 1], e = 0; b--;)
                                            c = +value[b], d += ++e % 2 ? 2 * c % 10 + (c > 4) : c;
                                        return (value.length >= min && value.length <= max && !(d % 10));
                                    }
                                ]]>
                            </script>
                        </xsl:if>
                        <div class="btn-group">
                            <input class="btn btn-primary" type="submit" tabindex="8" value="@PAY_NOW@"/>
                        </div>
                    </form>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="PROCESS_PAREQ">
        <xsl:call-template name="page-template">
            <xsl:with-param name="title">@PROCESS_PAREQ_TITLE@</xsl:with-param>
            <xsl:with-param name="content">
                <div class="center" style="width:310px;text-align:center;padding-top:6em" >@WAIT_PLEASE_MESSAGE@
                    <div style="padding-top:1em">
                        <div id="warningGradientOuterBarG">
                            <div id="warningGradientFrontBarG" class="warningGradientAnimationG">
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <xsl:call-template name="PAREQ_FORM"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="AUTOREFRESH">
        <xsl:if test="/payment-page/wait-please"><meta http-equiv="refresh" content="3;url='{/payment-page/wait-please/@refresh-url}'"/></xsl:if>
    </xsl:template>

    <xsl:template name="WAIT_PLEASE">
        <!--Variables-->
        <xsl:param name="REFRESH_URL"/>

        <!--Template-->
        <xsl:call-template name="page-template">
            <xsl:with-param name="title">@WAIT_PLEASE_TITLE@</xsl:with-param>
            <xsl:with-param name="content">
                <div class="center" style="width:310px;text-align:center;padding-top:6em">@WAIT_PLEASE_MESSAGE@
                    <div style="padding-top:1em">
                        <div id="warningGradientOuterBarG">
                            <div id="warningGradientFrontBarG" class="warningGradientAnimationG">
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                                <div class="warningGradientBarLineG"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="PAGE_EXPIRED">
        <!--Variables-->
        <xsl:param name="CONTINUE_URL"/>

        <!--Template-->
        <xsl:call-template name="page-template">
            <xsl:with-param name="title">@PAGE_EXPIRED_TITLE@</xsl:with-param>
            <xsl:with-param name="content">
                <div class="center">
                    <div class="only_text">@PAGE_EXPIRED_MESSAGE@@PAGE_EXPIRED_MESSAGE@</div>
                    <input type="submit" class="btn btn-primary" value="@CONTINUE@" onclick="javascript: location.replace('{$CONTINUE_URL}');" />
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="PAYMENT_RESULT">
        <!--Variables-->
        <xsl:param name="MERCHANT_BACK_URL"/>
        <xsl:param name="DATE"/>
        <xsl:param name="TRX_ID"/>
        <xsl:param name="CARD_TYPE"/>
        <xsl:param name="CARDHOLDER"/>
        <xsl:param name="PAN"/>
        <xsl:param name="EXPIRY"/>
        <xsl:param name="RESULT"/>
        <xsl:param name="RESULT_CODE"/>
        <xsl:param name="RESPONSE_CODE"/>
        <xsl:param name="REFERENCE_NUMBER"/>
        <xsl:param name="EMAIL_SENT"/>
        <xsl:param name="EMAIL"/>
        <xsl:param name="EMAIL_CHECK"/>

        <!--Template-->
        <xsl:call-template name="page-template">
            <xsl:with-param name="title">@PAYMENT_RESULT_TITLE@</xsl:with-param>
            <xsl:with-param name="content">
                <div class="payment-info">
                    <table>
                        <xsl:if test="$CARD_TYPE"><tr><td>@CARD_TYPE@:</td><td><xsl:value-of select="$CARD_TYPE"/></td></tr></xsl:if>
                        <xsl:if test="$CARDHOLDER"><tr><td>@CARDHOLDER@:</td><td><xsl:value-of select="$CARDHOLDER"/></td></tr></xsl:if>
                        <xsl:if test="$PAN"><tr><td>@PAN@:</td><td><xsl:value-of select="$PAN"/></td></tr></xsl:if>
                        <xsl:if test="$MERCHANT_URL"><tr><td>@MERCHANT_URL@:</td><td><a href="{$MERCHANT_URL}" target="_blank"><xsl:value-of select="$MERCHANT_URL"/></a></td></tr></xsl:if>
                        <xsl:if test="$TRX_ID"><tr><td>@TRANSACTION_NUMBER@:</td><td><xsl:value-of select="$TRX_ID"/></td></tr></xsl:if>
                        <tr><td>@DATE@:</td><td><xsl:value-of select="$DATE"/></td></tr>
                        <xsl:if test="$REFERENCE_NUMBER"><tr><td>@REFERENCE_NUMBER@:</td><td><xsl:value-of select="$REFERENCE_NUMBER"/></td></tr></xsl:if>
                        <tr>
                            <td>@RESULT@:</td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="$RESULT='ERROR'">
                                        <b class="red">
                                            <xsl:choose>
                                                <xsl:when test="$RESPONSE_CODE='101'">@P_ERROR_101@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='110'">@P_ERROR_110@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='111'">@P_ERROR_111@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='116'">@P_ERROR_116@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='118'">@P_ERROR_118@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='119'">@P_ERROR_119@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='120'">@P_ERROR_120@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='121'">@P_ERROR_121@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='123'">@P_ERROR_123@</xsl:when>
                                                <xsl:when test="$RESPONSE_CODE='125'">@P_ERROR_125@</xsl:when>
                                                <xsl:otherwise>@PAYMENT_ERROR@</xsl:otherwise>
                                            </xsl:choose>
                                        </b>
                                    </xsl:when>
                                    <xsl:when test="$RESULT='USER_CANCELLED'"><b class="red">@USER_CANCELLED@</b></xsl:when>
                                    <xsl:when test="$RESULT='CARDPAYMENT_ERROR'"><b class="red">@PAYMENT_ERROR@</b></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$WITH_REDIRECT = 'yes'">
                                            <script>
                                                document.getElementById("thebody").style.display = 'none';
                                                location.replace('<xsl:value-of select="$MERCHANT_BACK_URL"/>');
                                            </script>
                                        </xsl:if>
                                        <b class="green">@PAYMENT_COMPLETE@</b></xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>

                        <xsl:if test="$SHOW_EMAIL = 'yes'">
                            <xsl:choose>
                                <xsl:when test="$RESULT='COMPLETE_ONLINE' and not($EMAIL_SENT)">
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="$EMAIL_SENT">
                                        <script>
                                            (function()
                                            {
                                            var sPageURL = decodeURIComponent(window.location.search.substring(1));
                                            if(sPageURL.indexOf('block_email') == -1) {
                                            var key = encodeURI('block_email'); var value = encodeURI('true'),
                                            keyEmailSent = encodeURI('email_sent'), valueEmailSent = '<xsl:value-of
                                                select="$EMAIL_SENT"/>';

                                            var kvp = document.location.search.substr(1).split('<xsl:text
                                                disable-output-escaping="yes"><![CDATA[&]]></xsl:text>');
                                            var i=kvp.length; var x;
                                            while(i--)
                                            {
                                            x = kvp[i].split('=');
                                            if (x[0]==key)
                                            {
                                            x[1] = value;
                                            kvp[i] = x.join('=');
                                            break;
                                            }
                                            }
                                            if(i<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text>0)
                                            {kvp[kvp.length]
                                            = [key,value].join('=');
                                            }
                                            kvp[kvp.length] = [keyEmailSent,valueEmailSent].join('=');
                                            //this will reload the page, it's likely better to store this until finished
                                            document.location.search = kvp.join('<xsl:text
                                                disable-output-escaping="yes"><![CDATA[&]]></xsl:text>');
                                            }
                                            }());
                                        </script>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="$EMAIL_SENT='SUCCESS'">
                                            <tr>
                                                <td colspan="2" style="padding-top:10px;">
                                                    <span>
                                                        <span class="param">@EMAIL_SUCCESS@
                                                            <b>
                                                                <xsl:value-of select="$EMAIL"/>
                                                            </b>
                                                        </span>
                                                    </span>
                                                </td>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="$RESULT!='ERROR' and $RESULT!='USER_CANCELLED' and $RESULT!='CARDPAYMENT_ERROR'">
                                                <xsl:if test="$EMAIL_SENT='FAIL'">
                                                    <tr>
                                                        <td colspan="2" style="padding-top:10px;">
                                                            <span>
                                                                <span class="paramerror">@EMAIL_FAIL@</span>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </xsl:if>
                                                <xsl:if test="$EMAIL_SENT='UNKNOWN'">
                                                    <tr>
                                                        <td colspan="2" style="padding-top:10px;">
                                                            <span>
                                                                <span class="paramerror">@EMAIL_UNKNOWN@</span>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </xsl:if>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </table>




                    <xsl:if test="$RESULT='COMPLETE_OFFLINE'">
                        <div class="message">@PAYMENT_OFFLINE@</div>
                    </xsl:if>
                    <div class="result-form no-print">
                        <div class="btn-group">
                            <button class="btn no-mobile" type="button" onclick="javascript:window.print()">@PRINT_RESULT@</button>
                            <a href="{$MERCHANT_BACK_URL}" class="btn btn-primary btn-back">@RETURN_TO_MERCHANT@</a>
                        </div>
                    </div>

                    <xsl:if test="$SHOW_EMAIL = 'yes'">
                        <xsl:choose>
                            <xsl:when test="$RESULT='COMPLETE_ONLINE' and not($EMAIL_SENT)">
                                <script>
                                    window.onload = function() {
                                    function getUrlParameter(sParam) {
                                    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                                    sURLVariables = sPageURL.split('&amp;'),
                                    sParameterName,
                                    i;
                                    for (i = 0; i &lt; sURLVariables.length; i++) {
                                    sParameterName = sURLVariables[i].split('=');
                                    if (sParameterName[0] === sParam) {
                                    return sParameterName[1] === undefined ? true : sParameterName[1];}}}
                                    document.getElementById('ws.id').value = getUrlParameter('ws.id');
                                    };
                                </script>
                                <div class="email no-print">
                                    <span>@SEND_EMAIL_DESC@</span>

                                    <form name="p.email" action="current.wsm" method="GET" autocomplete="off" class="email_input_block">
                                        <span id="email-input" class="form-input">
                                            <input type="hidden" name="ws.id" id="ws.id"/>
                                            <input id="email" name="email" type="email"  value="{$EMAIL}" maxlength="40" placeholder="E-mail" required="required" />
                                            <span class="error-container"></span>
                                        </span>
                                        <input type="submit" class="btn btn-primary btn-email" id="email-link" value="@SEND_EMAIL@"/>
                                    </form>
                                </div>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>

                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--Other user templates-->
    <xsl:template name="page-template">
        <xsl:param name="title"/>
        <xsl:param name="content"/>
        <xsl:param name="PAN_MASKED"/>

        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <title><xsl:value-of select="$title"/></title>
                <link rel="stylesheet" type="text/css" href="{$RESOURCE_BASE}reset.css"/>
                <link rel="stylesheet" type="text/css" href="{$RESOURCE_BASE}style.css"/>
                <link rel="stylesheet" type="text/css" href="{$RESOURCE_BASE}css/all.css"/>
                <xsl:call-template name="AUTOREFRESH"/>
            </head>
            <body id="thebody">

                <div class="container">
                    <div class="window">
                        <xsl:copy-of select="$content"/>

                    </div>
                </div>

                <script src="{$RESOURCE_BASE}jquery-1.11.1.js"/>
                <script src="{$RESOURCE_BASE}jquery.validate.js"/>
                <script src="{$RESOURCE_BASE}jquery.mask.js"/>
                <script src="{$RESOURCE_BASE}script.js"/>
                <xsl:if test="$PAN_MASKED='true'">
                    <script>
                        detectBrand();
                    </script>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>