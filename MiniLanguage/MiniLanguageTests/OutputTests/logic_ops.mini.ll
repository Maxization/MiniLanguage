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
%n_1 = alloca i32
store i32 5, i32* %int
%tmp_378 = load i32, i32* %int
store i32 %tmp_378, i32* %n_1
%tmp_379 = load i32, i32* %n_1
store i32 1, i32* %int
%tmp_380 = load i32, i32* %int
store i32 2, i32* %int
%tmp_381 = load i32, i32* %int
%tmp_382 = icmp slt i32 %tmp_380, %tmp_381
br i1 %tmp_382, label %LABEL_67, label %LABEL_68
LABEL_68:
store i1 0, i1* %bool
br label %LABEL_69
LABEL_67:
store i32 3, i32* %int
%tmp_383 = load i32, i32* %int
store i32 4, i32* %int
%tmp_384 = load i32, i32* %int
%tmp_385 = icmp slt i32 %tmp_383, %tmp_384
%tmp_431 = and i1 %tmp_382, %tmp_385
store i1 %tmp_431, i1* %bool
br label %LABEL_69
LABEL_69:
%tmp_386 = load i1, i1* %bool
br i1 %tmp_386, label %LABEL_70, label %LABEL_71
LABEL_70:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_72
LABEL_71:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_72
LABEL_72:
%tmp_432 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_432
%tmp_433 = bitcast [2 x i8]* %tmp_432 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_433)
store i32 2, i32* %int
%tmp_387 = load i32, i32* %int
%tmp_388 = load i32, i32* %n_1
%tmp_389 = mul i32 %tmp_387, %tmp_388
store i32 3, i32* %int
%tmp_390 = load i32, i32* %int
%tmp_391 = load i32, i32* %n_1
%tmp_392 = mul i32 %tmp_390, %tmp_391
%tmp_393 = icmp slt i32 %tmp_389, %tmp_392
br i1 %tmp_393, label %LABEL_73, label %LABEL_74
LABEL_74:
store i1 0, i1* %bool
br label %LABEL_75
LABEL_73:
%tmp_394 = load i32, i32* %n_1
store i32 5, i32* %int
%tmp_395 = load i32, i32* %int
%tmp_396 = add i32 %tmp_394, %tmp_395
%tmp_397 = load i32, i32* %n_1
store i32 2, i32* %int
%tmp_398 = load i32, i32* %int
%tmp_399 = sub i32 %tmp_397, %tmp_398
%tmp_400 = icmp sge i32 %tmp_396, %tmp_399
%tmp_434 = and i1 %tmp_393, %tmp_400
store i1 %tmp_434, i1* %bool
br label %LABEL_75
LABEL_75:
%tmp_401 = load i1, i1* %bool
br i1 %tmp_401, label %LABEL_76, label %LABEL_77
LABEL_76:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_78
LABEL_77:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_78
LABEL_78:
%tmp_435 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_435
%tmp_436 = bitcast [2 x i8]* %tmp_435 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_436)
store i32 1, i32* %int
%tmp_402 = load i32, i32* %int
store i32 2, i32* %int
%tmp_403 = load i32, i32* %int
%tmp_404 = add i32 %tmp_402, %tmp_403
store i32 3, i32* %int
%tmp_405 = load i32, i32* %int
store double 1.0, double* %double
%tmp_406 = load double, double* %double
%tmp_437 = uitofp i32 %tmp_405 to double
%tmp_407 = fmul double %tmp_437, %tmp_406
%tmp_438 = uitofp i32 %tmp_404 to double
%tmp_408 = fcmp oeq double %tmp_438, %tmp_407
br i1 %tmp_408, label %LABEL_79, label %LABEL_80
LABEL_80:
store i1 0, i1* %bool
br label %LABEL_81
LABEL_79:
store i32 0, i32* %int
%tmp_409 = load i32, i32* %int
store double 1.0, double* %double
%tmp_410 = load double, double* %double
%tmp_440 = uitofp i32 %tmp_409 to double
%tmp_411 = fcmp oeq double %tmp_440, %tmp_410
%tmp_439 = and i1 %tmp_408, %tmp_411
store i1 %tmp_439, i1* %bool
br label %LABEL_81
LABEL_81:
%tmp_412 = load i1, i1* %bool
br i1 %tmp_412, label %LABEL_82, label %LABEL_83
LABEL_82:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_84
LABEL_83:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_84
LABEL_84:
%tmp_441 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_441
%tmp_442 = bitcast [2 x i8]* %tmp_441 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_442)
store i32 0, i32* %int
%tmp_413 = load i32, i32* %int
store i32 1, i32* %int
%tmp_414 = load i32, i32* %int
%tmp_415 = icmp slt i32 %tmp_413, %tmp_414
br i1 %tmp_415, label %LABEL_85, label %LABEL_86
LABEL_85:
store i1 1, i1* %bool
br label %LABEL_87
LABEL_86:
store i32 5, i32* %int
%tmp_416 = load i32, i32* %int
store i32 1, i32* %int
%tmp_417 = load i32, i32* %int
store i32 0, i32* %int
%tmp_418 = load i32, i32* %int
%tmp_419 = sdiv i32 %tmp_417, %tmp_418
%tmp_420 = icmp eq i32 %tmp_416, %tmp_419
%tmp_443 = or i1 %tmp_415, %tmp_420
store i1 %tmp_443, i1* %bool
br label %LABEL_87
LABEL_87:
%tmp_421 = load i1, i1* %bool
br i1 %tmp_421, label %LABEL_88, label %LABEL_89
LABEL_88:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_90
LABEL_89:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_90
LABEL_90:
%tmp_444 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_444
%tmp_445 = bitcast [2 x i8]* %tmp_444 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_445)
store i32 1, i32* %int
%tmp_422 = load i32, i32* %int
store i32 2, i32* %int
%tmp_423 = load i32, i32* %int
%tmp_424 = icmp eq i32 %tmp_422, %tmp_423
br i1 %tmp_424, label %LABEL_91, label %LABEL_92
LABEL_92:
store i1 0, i1* %bool
br label %LABEL_93
LABEL_91:
store i32 5, i32* %int
%tmp_425 = load i32, i32* %int
store i32 1, i32* %int
%tmp_426 = load i32, i32* %int
store i32 0, i32* %int
%tmp_427 = load i32, i32* %int
%tmp_428 = sdiv i32 %tmp_426, %tmp_427
%tmp_429 = icmp eq i32 %tmp_425, %tmp_428
%tmp_446 = and i1 %tmp_424, %tmp_429
store i1 %tmp_446, i1* %bool
br label %LABEL_93
LABEL_93:
%tmp_430 = load i1, i1* %bool
br i1 %tmp_430, label %LABEL_94, label %LABEL_95
LABEL_94:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_96
LABEL_95:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_96
LABEL_96:
ret i32 0
}
