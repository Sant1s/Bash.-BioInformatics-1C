#!/usr/bin/bash

save_head() {
    input_file=$1
    output_file=$2
    head_count=$3

    zcat "$input_file" | head -n "$((4 * head_count))" | gzip > "$output_file"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --input)
            input_file=$2
            shift 2
            ;;
        --output)
            output_file=$2
            shift 2
            ;;
        -q)
            quality_threshold=$2
            shift 2
            ;;
        --head)
            head_count=$2
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$input_file" || -z "$output_file" ]]; then
    echo "Please specify --input and --output options."
    exit 1
fi

if [[ ! -z "$head_count" ]]; then
    save_head "$input_file" "$output_file" "$head_count"
elif [[ ! -z "$quality_threshold" ]]; then
    filter_quality "$input_file" "$output_file" "$quality_threshold"
else
    echo "Please specify either --head or -q option."
    exit 1
fi
