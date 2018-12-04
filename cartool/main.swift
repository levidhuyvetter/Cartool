/*
- Project: Cartool
- File: main.swift
- Author: Levi Dhuyvetter
- Date: 03/12/2018
- Copyright: © 2018 Levi Dhuyvetter
- License: MIT
*/

import Foundation

if CommandLine.argc < 3 {
	//Print usage because there are not enough arguments.
	print("Usage: cartool <path to .car file> <path to output directory>")
	exit(2)
} else {
	let fileURL = URL(fileURLWithPath: CommandLine.arguments[1])
	let outputDirectory = URL(fileURLWithPath: CommandLine.arguments[2])
	
	export(carFile: fileURL, to: outputDirectory)
	exit(0)
}
