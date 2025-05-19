#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
'''
----------------------------------------------------------------------------------------
@File    :   build_r2s.py
@Time    :   2024/12/30 16:03:16
@Author  :   Lei Zheng
@Version :   1.0
@Contact :   type.zheng@gmail.com
----------------------------------------------------------------------------------------
'''


import argparse
import json
import gzip
import xml.etree.ElementTree as ET

def normalize_to_0_100(values):
    min_val = min(values)
    max_val = max(values)
    return [(val - min_val) / (max_val - min_val) * 100 for val in values]

def extract_json(svg_file, dbn_file, anno_file, score_file, output_path):
    tree = ET.parse(svg_file)
    root = tree.getroot()

    width = root.get('width')
    height = root.get('height')
    # print(f"SVG width: {width}, SVG height: {height}")

    extracted_data = {
        'name': '',
        'length': '',
        'structure': '',
        'base_pair': [],
        'base_line': [],
        'base_name': []
    }

    scale_x = 1
    scale_y = 1
    translate_x = 1
    translate_y = 1
    text_translate_x = 1
    text_translate_y = 1
    number_flag = 1
    elements = list(root.iter())

    for element in elements:
        if element.tag.endswith('g'):
            transform_value = element.get('transform')
            bp_id = element.get('id')
            if transform_value and bp_id != 'seq':
                scale_value = transform_value.split(" ")[0]
                translate_value = transform_value.split(" ")[1]
                scale_x = float(scale_value.replace('scale(', '').replace(')', '').split(",")[0])
                scale_y = float(scale_value.replace('scale(', '').replace(')', '').split(",")[1])
                translate_x = float(translate_value.replace('translate(', '').replace(')', '').split(",")[0])
                translate_y = float(translate_value.replace('translate(', '').replace(')', '').split(",")[1])
            elif bp_id == 'seq':
                text_translate_x = float(transform_value.replace('translate(', '').replace(')', '').split(",")[0])
                text_translate_y = float(transform_value.replace('translate(', '').replace(')', '').split(",")[1])
                


        elif element.tag.endswith('line'):
            class_name = element.get('class')
            # print('class_name', class_name)

            if class_name == 'basepairs':
                x1_value = (float(element.get('x1')) + translate_x) * scale_x
                y1_value = (float(element.get('y1')) + translate_y) * scale_y
                x2_value = (float(element.get('x2')) + translate_x) * scale_x
                y2_value = (float(element.get('y2')) + translate_y) * scale_y
                bp_id = element.get('id')
                extracted_data['base_pair'].append({'id': bp_id, 'x1': x1_value, 'y1': y1_value, 'x2': x2_value, 'y2': y2_value})
            elif class_name == 'backbone':
                points = element.get("points").strip().split()
                for x, y in [ele.split(",") for ele in points]:
                    base_line_x = (float(x) + translate_x) * scale_x
                    base_line_y = (float(y) + translate_y) * scale_y
                    extracted_data['base_line'].append({'x': base_line_x, 'y': base_line_y})

        elif element.tag.endswith('text'):
            class_name = element.get('class')
            if class_name == 'nucleotide':
                x_value = (float(element.get('x')) + text_translate_x + translate_x) * scale_x
                y_value = (float(element.get('y')) + text_translate_y + translate_y) * scale_y
                text_content = element.text

                extracted_data['base_name'].append({'id': number_flag, 'x': x_value, 'y': y_value, 'text': text_content})
                number_flag += 1

    with open(dbn_file) as f_obj:
        for i, line in enumerate(f_obj.readlines()):
            if i == 2:
                extracted_data['structure'] = line.strip()
                extracted_data['length'] = len(extracted_data['structure'])
            elif i == 0:
                trans_name = line.strip().split(".")[0][1:]
                extracted_data['name'] = trans_name

    with open(anno_file) as f_obj:
        lines = f_obj.readlines()
        name = lines[0].replace("#Name:", "").split("_")[0].strip()
        length = lines[1].replace("#Length:", "").strip()
        sequence = lines[3].strip()
        structure = lines[4].strip()
        structure_anno = lines[5].strip()

        extracted_data['name'] = name
        extracted_data['length'] = length
        extracted_data['sequence'] = sequence
        extracted_data['structure'] = structure
        extracted_data['structure_anno'] = structure_anno

    with open(score_file, "r") as file:
        file_data = file.read()

    data_sets = file_data.strip().split("&")
    score_names = ["pp", "mfe", "entropy"]

    for j, data_set in enumerate(data_sets):
        lines = data_set.strip().split("\n")
        x = []
        y = []
        for i, line in enumerate(lines):
            if i > 0:
                parts = line.split()
                x.append(float(parts[0]))
                y.append(float(parts[1]))
        if len(y) > 1:
            score_name = score_names[j]
            norm_x = normalize_to_0_100(x)
            norm_y = normalize_to_0_100(y)
            extracted_data[score_name] = norm_y

    json_data = json.dumps(extracted_data, indent=2)
    with gzip.open(f'{output_path}/{extracted_data["name"]}.r2s', 'wb') as f_obj:
        f_obj.write(json_data.encode('utf-8'))
    # with open(f'{output_path}/{extracted_data["name"]}.json', 'wb') as f_obj:
    #     f_obj.write(json_data.encode('utf-8'))

def main():
    parser = argparse.ArgumentParser(description="Extract data from SVG, DBN, annotation, and score files to R2S format.")
    parser.add_argument('--svg_file', required=True, help="Path to the SVG file.")
    parser.add_argument('--dbn_file', required=True, help="Path to the DBN file.")
    parser.add_argument('--anno_file', required=True, help="Path to the annotation file.")
    parser.add_argument('--score_file', required=True, help="Path to the score file.")
    parser.add_argument('--output_path', required=True, help="Path to save the output R2S file.")

    args = parser.parse_args()

    extract_json(args.svg_file, args.dbn_file, args.anno_file, args.score_file, args.output_path)

if __name__ == "__main__":
    main()
