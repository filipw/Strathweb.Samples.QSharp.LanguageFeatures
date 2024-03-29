﻿namespace QSharp.Shuffle {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    @EntryPoint()
    operation Main() : Unit {
        let array = MappedOverRange(i -> i, 0..10);
        Message($"Ordered array: {array}");

        let shuffled = Shuffled(array);
        Message($"Shuffled array: {shuffled}");

        let balancedBoolArray1 = BalancedBoolArrayV1(8);
        Message($"Balanced bool array V1: {balancedBoolArray1}");

        let balancedBoolArray2 = BalancedBoolArrayV2(8);
        Message($"Balanced bool array V2: {balancedBoolArray2}");
    }

    operation Shuffled<'T>(array : 'T[]) : 'T[] {
        let arrayLength = Length(array);
        if arrayLength <= 1 {
            return array;
        }

        mutable shuffled = array;

        for i in 0..arrayLength - 2 {
            let j = DrawRandomInt(i, arrayLength - 1);
            set shuffled = Swapped(i, j, shuffled);
        }

        shuffled
    }

    operation BalancedBoolArrayV1(size: Int) : Bool[] {
        mutable trueCount = 0;
        mutable falseCount = 0;
        mutable resultArray = [];

        Fact(size % 2 == 0, "Size must be divisible by 2");
        let halfSize = size / 2;

        for i in 0..size - 1 {
            if trueCount < halfSize and falseCount < halfSize {
                let randomBit = DrawRandomInt(0, 1) == 1;
                if randomBit {
                    set trueCount += 1;
                } else {
                    set falseCount += 1;
                }
                set resultArray += [randomBit];
            } elif trueCount >= halfSize {
                set resultArray += [false];
            }
            else {
                set resultArray += [true];
            }
        }

        resultArray
    }

    operation BalancedBoolArrayV2(size: Int) : Bool[] {
        Fact(size % 2 == 0, "Size must be divisible by 2");
        
        let array = [true, size = size/2];
        Shuffled(Padded(-size, false, array))
    }
}

