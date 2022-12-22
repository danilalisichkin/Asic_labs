#include <iostream>
#pragma inline

using namespace std;

void main() {

	float* array = new float[10];
	float buffer;
	float result = 0;
	for (int i = 0; i < 10; i++) {
		do {
			std::cout << "mas[" << i << "] : ";
			std::cin >> buffer;
			if (std::cin.good()) {
				array[i] = buffer;
				break;
			}
			else {
				rewind(stdin);
				std::cin.clear();
			}
		} while (true);
	}

	_asm {
		xor ecx, ecx
		mov ecx, 10
		finit
		mov eax, array
		fld result
		start:
			fadd[eax]
			add eax, 4
		loop start
		fst result
	}

	cout << result;
	system("pause");
}