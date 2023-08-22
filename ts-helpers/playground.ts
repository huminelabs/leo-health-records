// Inputs
let inputString = "Humine and UNMC Pilot Study"
let inputBigInt: bigint = BigInt("49937943936569109301441477574611358837317429773653802777488225608")
let inputDateString = "2023-09-19T20:23:01.804Z";
let inputDateInt = 1468959781804;

// Helper methods --> from https://github.com/demox-labs/art-factory/blob/8ea4aeb31e9e6a49813eabfb3ae8b1570bfe8d03/src/lib/util.ts
export function stringToBigInt(input: string): bigint {
    const encoder = new TextEncoder();
    const encodedBytes = encoder.encode(input);

    let bigIntValue = BigInt(0);
    for (let i = 0; i < encodedBytes.length; i++) {
        const byteValue = BigInt(encodedBytes[i]);
        const shiftedValue = byteValue << BigInt(8 * i);
        bigIntValue = bigIntValue | shiftedValue;
    }

    return bigIntValue;
}

export function bigIntToString(bigIntValue: bigint): string {
    const bytes: number[] = [];
    let tempBigInt = bigIntValue;

    while (tempBigInt > BigInt(0)) {
        const byteValue = Number(tempBigInt & BigInt(255));
        bytes.push(byteValue);
        tempBigInt = tempBigInt >> BigInt(8);
    }

    const decoder = new TextDecoder();
    const asciiString = decoder.decode(Uint8Array.from(bytes));
    return asciiString;
}

// Outputs
let convertedToDate = new Date(inputDateString);
let dateTime = convertedToDate.getTime();

let intOutputFromString = stringToBigInt(inputString);
let stringOutputFromInt = bigIntToString(inputBigInt);


// Console print
console.log("String to Int: " + intOutputFromString);
console.log("Confirming: " + bigIntToString(intOutputFromString));
console.log("");
console.log("Int to String: " + stringOutputFromInt);
console.log("Confirming: " + stringToBigInt(stringOutputFromInt));
console.log("");
console.log("Date to Int: " + dateTime);
console.log("Confirming: " + new Date(dateTime));
console.log("");
console.log("Int to Date: " + new Date(inputDateInt));