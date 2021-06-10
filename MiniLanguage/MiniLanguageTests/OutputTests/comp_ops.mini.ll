; prolog
@int_res = constant [3 x i8] c"%d\00"
@hex_res = constant [5 x i8] c"0X%X\00"
@double_res = constant [4 x i8] c"%lf\00"
@true_res = constant [5 x i8] c"True\00"
@false_res = constant [6 x i8] c"False\00"
@int_read = constant [ 3 x i8] c"%d\00"
@hex_read = constant [3 x i8] c"%X\00"
@double_read = constant [ 4 x i8] c"%lf\00"
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)
define i32 @main()
{
%int = alloca i32
%double = alloca double
%bool = alloca i1
%a_1 = alloca i1
%z1_2 = alloca double
%z2_3 = alloca double
store i1 1, i1* %bool
%tmp_207 = load i1, i1* %bool
store i1 1, i1* %bool
%tmp_208 = load i1, i1* %bool
%tmp_209 = icmp eq i1 %tmp_207, %tmp_208
store i1 %tmp_209, i1* %a_1
%tmp_210 = load i1, i1* %a_1
%tmp_211 = load i1, i1* %a_1
br i1 %tmp_211, label %LABEL_37, label %LABEL_38
LABEL_37:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_39
LABEL_38:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_39
LABEL_39:
%tmp_254 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_254
%tmp_255 = bitcast [2 x i8]* %tmp_254 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_255)
store i1 0, i1* %bool
%tmp_212 = load i1, i1* %bool
store i1 0, i1* %bool
%tmp_213 = load i1, i1* %bool
%tmp_214 = icmp ne i1 %tmp_212, %tmp_213
store i1 %tmp_214, i1* %a_1
%tmp_215 = load i1, i1* %a_1
%tmp_216 = load i1, i1* %a_1
br i1 %tmp_216, label %LABEL_40, label %LABEL_41
LABEL_40:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_42
LABEL_41:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_42
LABEL_42:
%tmp_256 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_256
%tmp_257 = bitcast [2 x i8]* %tmp_256 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_257)
store i1 1, i1* %bool
%tmp_217 = load i1, i1* %bool
store i1 0, i1* %bool
%tmp_218 = load i1, i1* %bool
%tmp_219 = icmp eq i1 %tmp_217, %tmp_218
store i1 %tmp_219, i1* %a_1
%tmp_220 = load i1, i1* %a_1
%tmp_221 = load i1, i1* %a_1
br i1 %tmp_221, label %LABEL_43, label %LABEL_44
LABEL_43:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_45
LABEL_44:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_45
LABEL_45:
%tmp_258 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_258
%tmp_259 = bitcast [2 x i8]* %tmp_258 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_259)
store i32 1, i32* %int
%tmp_222 = load i32, i32* %int
store i32 2, i32* %int
%tmp_223 = load i32, i32* %int
%tmp_224 = icmp eq i32 %tmp_222, %tmp_223
br i1 %tmp_224, label %LABEL_46, label %LABEL_47
LABEL_46:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_48
LABEL_47:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_48
LABEL_48:
%tmp_260 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_260
%tmp_261 = bitcast [2 x i8]* %tmp_260 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_261)
store double 5.0, double* %double
%tmp_225 = load double, double* %double
store i32 5, i32* %int
%tmp_226 = load i32, i32* %int
%tmp_262 = uitofp i32 %tmp_226 to double
%tmp_227 = fcmp ole double %tmp_225, %tmp_262
br i1 %tmp_227, label %LABEL_49, label %LABEL_50
LABEL_49:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_51
LABEL_50:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_51
LABEL_51:
%tmp_263 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_263
%tmp_264 = bitcast [2 x i8]* %tmp_263 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_264)
store i32 0, i32* %int
%tmp_228 = load i32, i32* %int
store double 0.0, double* %double
%tmp_229 = load double, double* %double
%tmp_265 = uitofp i32 %tmp_228 to double
%tmp_230 = fcmp oge double %tmp_265, %tmp_229
br i1 %tmp_230, label %LABEL_52, label %LABEL_53
LABEL_52:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_54
LABEL_53:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_54
LABEL_54:
%tmp_266 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_266
%tmp_267 = bitcast [2 x i8]* %tmp_266 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_267)
store i32 5, i32* %int
%tmp_231 = load i32, i32* %int
store i32 5, i32* %int
%tmp_232 = load i32, i32* %int
%tmp_233 = icmp eq i32 %tmp_231, %tmp_232
br i1 %tmp_233, label %LABEL_55, label %LABEL_56
LABEL_55:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_57
LABEL_56:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_57
LABEL_57:
%tmp_268 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_268
%tmp_269 = bitcast [2 x i8]* %tmp_268 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_269)
store double 1.0, double* %double
%tmp_234 = load double, double* %double
store double %tmp_234, double* %z1_2
%tmp_235 = load double, double* %z1_2
store double 2.0, double* %double
%tmp_236 = load double, double* %double
store double %tmp_236, double* %z2_3
%tmp_237 = load double, double* %z2_3
%tmp_238 = load double, double* %z1_2
%tmp_239 = load double, double* %z2_3
%tmp_240 = fcmp olt double %tmp_238, %tmp_239
store i1 1, i1* %bool
%tmp_241 = load i1, i1* %bool
%tmp_242 = icmp eq i1 %tmp_240, %tmp_241
br i1 %tmp_242, label %LABEL_58, label %LABEL_59
LABEL_58:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_60
LABEL_59:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_60
LABEL_60:
%tmp_270 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_270
%tmp_271 = bitcast [2 x i8]* %tmp_270 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_271)
store i32 2, i32* %int
%tmp_243 = load i32, i32* %int
store i32 2, i32* %int
%tmp_244 = load i32, i32* %int
store i32 2, i32* %int
%tmp_245 = load i32, i32* %int
%tmp_246 = add i32 %tmp_244, %tmp_245
%tmp_247 = add i32 %tmp_243, %tmp_246
store i32 2, i32* %int
%tmp_248 = load i32, i32* %int
store i32 2, i32* %int
%tmp_249 = load i32, i32* %int
%tmp_250 = add i32 %tmp_248, %tmp_249
store i32 2, i32* %int
%tmp_251 = load i32, i32* %int
%tmp_252 = mul i32 %tmp_250, %tmp_251
%tmp_253 = icmp slt i32 %tmp_247, %tmp_252
br i1 %tmp_253, label %LABEL_61, label %LABEL_62
LABEL_61:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_63
LABEL_62:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_63
LABEL_63:
ret i32 0
}
