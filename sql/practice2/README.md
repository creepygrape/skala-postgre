problem3 : RIGHT JOIN 써보기
problem5 : NOT IN 말고 NOT EXISTS
problem11 : LIMIT 여부에 따라 출력 결과가 달라짐. LIMIT을 붙이면 PostgreSQL 더 빠르게 N개만 찾는 실행 계획을 선택할 수 있어서 반환 순서가 달라질 수 있음
- LIMIT이 없을 때 (ORDER BY만 있는 경우): 전체 데이터를 전부 다 가져와서 디스크나 메모리에 올린 뒤, 전체 대상을 정렬합니다. 데이터가 많다면 External Merge Sort 같은 무거운 정렬 방식을 씁니다.
- LIMIT이 있을 때 (ORDER BY + LIMIT N): PostgreSQL은 메모리상에 크기가 N인 미니 허프(Heap, 우선순위 큐)를 만듭니다. 데이터를 하나씩 읽으면서 상위 N개 안에 들지 않는 나머지는 즉시 버리며 가볍게 정렬합니다.