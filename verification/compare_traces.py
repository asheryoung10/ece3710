#!/usr/bin/env python3
import argparse
import csv
from pathlib import Path


KEY_COLUMNS = [
    "pc",
    "instruction",
    "opcodeCombined",
    "rd",
    "rs",
    "immSigned",
    "regWrite",
    "regWriteAddr",
    "regWriteValue",
    "memWrite",
    "memWriteAddr",
    "memWriteValue",
    "flags",
]


def load_rows(path: Path):
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)
    for idx, row in enumerate(rows):
        row["_row"] = idx
    return rows


def normalize_row(row):
    normalized = {}
    for key in KEY_COLUMNS:
        value = row.get(key, "").strip()
        normalized[key] = value.lower() if value.startswith("0x") else value
    return normalized


def compare(sim_rows, hdl_rows, context):
    limit = min(len(sim_rows), len(hdl_rows))
    for i in range(limit):
        sim_norm = normalize_row(sim_rows[i])
        hdl_norm = normalize_row(hdl_rows[i])
        if sim_norm != hdl_norm:
            start = max(0, i - context)
            end = min(limit, i + context + 1)
            return False, i, (start, end)
    if len(sim_rows) != len(hdl_rows):
        return False, limit, (max(0, limit - context), limit)
    return True, -1, (0, 0)


def print_context(sim_rows, hdl_rows, index_range):
    start, end = index_range
    print(f"Context rows [{start}, {end}):")
    for i in range(start, end):
        sim = normalize_row(sim_rows[i]) if i < len(sim_rows) else None
        hdl = normalize_row(hdl_rows[i]) if i < len(hdl_rows) else None
        marker = ">>" if sim != hdl else "  "
        print(f"{marker} row {i}")
        print(f"   sim: {sim}")
        print(f"   hdl: {hdl}")


def main():
    parser = argparse.ArgumentParser(description="Compare simulator and HDL CPU execution traces.")
    parser.add_argument("--sim", required=True, type=Path, help="Path to simulator trace CSV.")
    parser.add_argument("--hdl", required=True, type=Path, help="Path to HDL trace CSV.")
    parser.add_argument("--context", type=int, default=3, help="Context rows around first mismatch.")
    args = parser.parse_args()

    sim_rows = load_rows(args.sim)
    hdl_rows = load_rows(args.hdl)

    equal, mismatch_index, index_range = compare(sim_rows, hdl_rows, args.context)
    if equal:
        print(f"PASS: traces match for {len(sim_rows)} rows.")
        return 0

    if mismatch_index >= 0:
        print(f"FAIL: first mismatch at row {mismatch_index}")
    else:
        print("FAIL: trace lengths differ.")
        print(f"sim rows={len(sim_rows)} hdl rows={len(hdl_rows)}")
    print_context(sim_rows, hdl_rows, index_range)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
