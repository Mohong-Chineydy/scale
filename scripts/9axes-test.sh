#!/bin/bash

################################################################################
# 9Axes 政治倾向量表测试 - 交互式Bash脚本
# 功能：通过题目测试用户的政治倾向（16维度扩展版）
# 作者：Copilot
# 日期：2026-05-30
################################################################################

# ============================================================================
# 全局变量定义
# ============================================================================

# 当前题目索引和总题数
CURRENT_QUESTION=0
TOTAL_QUESTIONS=0

# 用户答案数组和维度得分
declare -a USER_ANSWERS=()
declare -A DIMENSION_SCORES=(
    [economic]=0
    [political]=0
    [social]=0
    [authoritarianism]=0
    [militarism]=0
    [nationalism]=0
    [religion]=0
    [progress]=0
    [tradition]=0
    [environmentalism]=0
    [individualism]=0
    [collectivism]=0
    [scientific]=0
    [pragmatism]=0
    [idealism]=0
    [localism]=0
)

# 维度说明
declare -A DIMENSION_NAMES=(
    [economic]="经济维度"
    [political]="政治维度"
    [social]="社会维度"
    [authoritarianism]="权力集中度"
    [militarism]="军国主义倾向"
    [nationalism]="民族主义倾向"
    [religion]="宗教信仰度"
    [progress]="进步倾向"
    [tradition]="传统倾向"
    [environmentalism]="环保主义"
    [individualism]="个人主义"
    [collectivism]="集体主义"
    [scientific]="科学理性"
    [pragmatism]="务实主义"
    [idealism]="理想主义"
    [localism]="本地化倾向"
)

# 题库定义（维度, 题目文本）
declare -a QUESTIONS=(
    # 经济维度 (0-14) - 15道题
    "economic|政府应该通过高税收来重新分配财富，以减少贫富差距。"
    "economic|私有企业和自由市场应该是经济的主要驱动力。"
    "economic|基本生活保障（食物、住房、医疗）应该由政府确保。"
    "economic|累进税制是解决不平等的有效方式。"
    "economic|大型企业的垄断行为应该受到严格监管。"
    "economic|最低工资法律会导致失业和经济低迷。"
    "economic|工会对保护工人权益至关重要。"
    "economic|公共医疗系统比私人医疗系统更有效。"
    "economic|教育应该是免费和普遍accessible的。"
    "economic|政府补贴农业是浪费纳税人的钱。"
    "economic|社会福利项目应该被减少以降低政府支出。"
    "economic|国有企业比私营企业更有效率。"
    "economic|全球贸易自由化对国家经济有益。"
    "economic|技术创新应该由市场驱动，而非政府干预。"
    "economic|贫困是由于个人失败，而非制度问题。"
    
    # 政治维度 (15-29) - 15道题
    "political|权力应该集中在中央政府手中以提高效率。"
    "political|地方政府应该拥有更多独立的决策权。"
    "political|多党制民主是最好的政治制度。"
    "political|在国家安全问题上，政府应该有更多的权力。"
    "political|权力的制衡和分权对民主制度至关重要。"
    "political|一党制能够更有效地治理国家。"
    "political|人民应该直接参与重大政策决定（直接民主）。"
    "political|代议制民主优于直接民主。"
    "political|政治权力应该世袭和保留给精英阶层。"
    "political|普遍成人选举权是现代民主的基础。"
    "political|宪法对限制政府权力至关重要。"
    "political|司法独立是民主社会的必要条件。"
    "political|政府问责和透明度应该是最高优先级。"
    "political|权力的集中能够更好地实现国家目标。"
    "political|公民参与和监督对民主健康至关重要。"
    
    # 社会维度 (30-44) - 15道题
    "social|同性婚姻应该被法律所认可和保护。"
    "social|传统家庭价值观对社会稳定至关重要。"
    "social|大麻等软性毒品应该被合法化。"
    "social|言论自由应该是绝对的，没有任何限制。"
    "social|社会应该保护少数族裔和移民的权益。"
    "social|堕胎应该是女性的自主选择。"
    "social|宗教应该在公共教育中占据突出地位。"
    "social|性少数群体应该享有平等的法律地位。"
    "social|传统性别角色对社会稳定是必要的。"
    "social|文化多元性对社会进步有益。"
    "social|色情制品应该被禁止以保护公众道德。"
    "social|离婚法律应该更宽松以增加个人自由。"
    "social|公共场所表达宗教信仰应该被保护。"
    "social|社会应该积极推动性别平等。"
    "social|传统婚姻和家庭制度应该被优先支持。"
    
    # 权力集中度/专制倾向 (45-59) - 15道题
    "authoritarianism|强大的领导力对国家发展是必要的。"
    "authoritarianism|个人自由比安全和秩序更重要。"
    "authoritarianism|政府应该详细监控公民的活动以维护安全。"
    "authoritarianism|在紧急情况下，执行部门应该拥有绝对权力。"
    "authoritarianism|人权应该不受任何政府权力的限制。"
    "authoritarianism|国家安全可以证明侵犯隐私是正当的。"
    "authoritarianism|强有力的中央权力能够更好地维护社会秩序。"
    "authoritarianism|公民应该无条件服从法律和政府命令。"
    "authoritarianism|规则和纪律对社会运作至关重要。"
    "authoritarianism|个人自由应该受到法律和社会秩序的约束。"
    "authoritarianism|警察应该有更广泛的权力来维护秩序。"
    "authoritarianism|异议和反对应该受到严格限制。"
    "authoritarianism|生命中需要有明确的权威和等级制度。"
    "authoritarianism|民众应该能够质疑和反对政府决定。"
    "authoritarianism|集体利益应该优先于个人权利。"
    
    # 军国主义倾向 (60-74) - 15道题
    "militarism|国防支出对国家来说是必要的投资。"
    "militarism|和平解决国际争端总是比军事干预更好。"
    "militarism|拥有强大的军队是国家威慑力的基础。"
    "militarism|提高军队预算应该是优先事项。"
    "militarism|国家不应该干预其他国家的内政。"
    "militarism|军事力量是国际谈判中的重要工具。"
    "militarism|和平主义是一种幼稚和不切实际的理想。"
    "militarism|国防工业是国家经济中至关重要的部分。"
    "militarism|军事冲突可以通过外交谈判避免。"
    "militarism|拥核国家有权力维护全球和平。"
    "militarism|军队在维护国家安全中起关键作用。"
    "militarism|过度的军事开支会伤害社会福利计划。"
    "militarism|战争永远无法解决根本性的国际分歧。"
    "militarism|国防能力决定了国家的国际地位。"
    "militarism|国际武装冲突最好通过联合国解决。"
    
    # 民族主义/全球化 (75-89) - 15道题
    "nationalism|国家利益应该优先于全球利益。"
    "nationalism|国际��作和全球治理对未来至关重要。"
    "nationalism|本国文化应该得到特别保护和推崇。"
    "nationalism|移民限制政策有助于保护本国就业机会。"
    "nationalism|全球化对国家经济发展有利。"
    "nationalism|国家主权不应该因国际协议而妥协。"
    "nationalism|多国企业应该对其本国政府负责。"
    "nationalism|文化同化是移民融合的必要条件。"
    "nationalism|国家应该优先支持本国产品而非进口商品。"
    "nationalism|国际组织应该尊重各国的主权和差异。"
    "nationalism|民族身份对社会凝聚力至关重要。"
    "nationalism|全球化导致了文化特色的丧失。"
    "nationalism|本国公民应该在就业中被优先考虑。"
    "nationalism|国际贸易协议通常对本国不利。"
    "nationalism|全球化使国家更容易受到外部威胁。"
    
    # 宗教/世俗主义 (90-104) - 15道题
    "religion|宗教信仰对社会道德基础至关重要。"
    "religion|宗教应该在政治决定中扮演关键角色。"
    "religion|政府应该保持完全的世俗性和中立。"
    "religion|宗教教育应该是学校课程的重要组成部分。"
    "religion|无神论者和信教者应该享有相同的权利和地位。"
    "religion|宗教自由是基本人权。"
    "religion|宗教机构应该免征税收以支持其使命。"
    "religion|政府不应该为宗教活动或建筑提供资金。"
    "religion|宗教信仰应该被纳入国家政策制定。"
    "religion|世俗社会比宗教社会更加理性和进步。"
    "religion|宗教反对科学进步和理性思维。"
    "religion|宗教对个人道德发展至关重要。"
    "religion|宗教在现代社会中应该衰退。"
    "religion|宗教信仰和科学知识可以和谐共存。"
    "religion|国家不应该对宗教事务进行任何干预。"
    
    # 进步vs传统 (105-119) - 15道题
    "progress|社会应该不断进步和改变。"
    "progress|传统做事方式通常是最好的。"
    "progress|现代化和工业化对人类进步至关重要。"
    "progress|保护传统文化和习俗很重要。"
    "progress|环境保护应该是社会的首要任务。"
    "progress|技术进步总是对社会有益的。"
    "progress|我们应该回到更传统和简单的生活方式。"
    "progress|社会应该接受和推进新的想法和方式。"
    "progress|历史上的传统做法通常比现代替代品更好。"
    "progress|进步有时需要打破传统的限制。"
    "progress|传统应该被保护以维持社会稳定。"
    "progress|创新和改革是解决社会问题的关键。"
    "progress|我们的祖先的做事方式值得尊重。"
    "progress|社会应该不断发展和改善。"
    "progress|人类的最佳时代在过去，而非未来。"
    
    # 环保主义 (120-134) - 15道题
    "environmentalism|环境保护应该优先于经济发展。"
    "environmentalism|气候变化是人类面临的最大威胁。"
    "environmentalism|绿色能源应该被大力推广和补贴。"
    "environmentalism|工业活动对环境的影响应该被严格控制。"
    "environmentalism|环境法规通常对经济增长有害。"
    "environmentalism|野生动物和生态系统应该被优先保护。"
    "environmentalism|可持续发展是经济增长的必要条件。"
    "environmentalism|个人消费应该受到限制以保护环境。"
    "environmentalism|环保活动家通常过度夸大问题。"
    "environmentalism|企业应该为其环境污染承担责任。"
    "environmentalism|环境危机主要是由于人类活动引起的。"
    "environmentalism|回收和废物管理应该由个人责任推动。"
    "environmentalism|林业和土地使用应该受到严格监管。"
    "environmentalism|环保技术的成本太高，不切实际。"
    "environmentalism|未来世代有权继承健康的地球。"
    
    # 个人主义vs集体主义 (135-149) - 15道题
    "individualism|个人自由和权利应该是社会的优先事项。"
    "individualism|个人成功应该基于个人努力和才能。"
    "individualism|社会应该尊重个人的多样性和差异。"
    "individualism|集体利益不应该牺牲个人权利。"
    "individualism|竞争促进社会进步和创新。"
    "individualism|个人应该对自己的命运负责。"
    "individualism|社会义务应该根据个人自愿性。"
    "individualism|个人隐私权应该得到绝对保护。"
    "individualism|富人应该对穷人有帮助的义务吗？不应该。"
    "individualism|个人选择应该不受社会限制。"
    "individualism|社会应该优先考虑集体福祉而非个人利益。"
    "individualism|共同责任对社会稳定至关重要。"
    "individualism|个人应该为社会的进步做出贡献。"
    "individualism|集体决策通常比个人决策更好。"
    "individualism|团队合作比个人成就更重要。"
    
    # 科学理性主义 (150-164) - 15道题
    "scientific|科学方法是理解世界的最佳方式。"
    "scientific|所有医疗决定应该基于科学证据。"
    "scientific|进化论是生物学的基础。"
    "scientific|疫苗接种对公共健康至关重要。"
    "scientific|替代医学通常是伪科学。"
    "scientific|科学研究应该不受政治干预。"
    "scientific|直觉和传统知识与科学一样有效。"
    "scientific|科技发展应该受到伦理审查和限制。"
    "scientific|大多数反科学的信念是有害的。"
    "scientific|科学应该是政策制定的基础。"
    "scientific|气候科学的共识是可靠的。"
    "scientific|宗教和科学是不可调和的。"
    "scientific|科学研究的资金应该增加。"
    "scientific|科技的发展总是有益的。"
    "scientific|对科学持怀疑态度是不理性的。"
    
    # 务实主义vs理想主义 (165-179) - 15道题
    "pragmatism|实际结果比原则和理想更重要。"
    "pragmatism|政治应该基于现实和可行性。"
    "pragmatism|妥协通常是解决分歧的最佳方式。"
    "pragmatism|道德绝对主义是不切实际的。"
    "pragmatism|目标的正确性取决于其结果。"
    "pragmatism|理想主义通常导致不切实际的政策。"
    "pragmatism|解决问题的最好方法是务实的。"
    "pragmatism|原则有时应该为实际利益而妥协。"
    "pragmatism|追求理想往往浪费时间和资源。"
    "pragmatism|政治中存在绝对的对错是幼稚的想法。"
    "pragmatism|道德原则应该指导所有行动。"
    "pragmatism|理想和价值观对社会进步至关重要。"
    "pragmatism|不应该为了结果而放弃原则。"
    "pragmatism|完美不应该阻碍进步。"
    "pragmatism|长期的道德立场比短期收益更重要。"
    
    # 本地化vs全球化 (180-194) - 15道题
    "localism|本地生产和消费应该被优先推崇。"
    "localism|全球化导致了文化和语言的损失。"
    "localism|本地政府比国家政府更有效。"
    "localism|社区应该自决而不受国家指导。"
    "localism|进口商品应该被本地产品替代。"
    "localism|全球贸易对小企业和农民有害。"
    "localism|本地食品系统优于工业农业。"
    "localism|传统手工艺应该被保护和推广。"
    "localism|全球化使财富和权力高度集中。"
    "localism|本地多样性应该被视为资产。"
    "localism|国际合作和贸易对经济增长至关重要。"
    "localism|全球化创造了更多的就业机会。"
    "localism|国家市场应该对国际竞争开放。"
    "localism|全球供应链提高了商品的可获得性。"
    "localism|全球互联网使知识民主化。"
)

# ============================================================================
# 工具函数
# ============================================================================

# 获取当前时间（格式：YYYY-MM-DD HH:MM:SS）
get_current_time() {
    date "+%Y-%m-%d %H:%M:%S"
}

# 清屏
clear_screen() {
    clear
}

# 打印分隔线
print_separator() {
    printf "────────────────────────────────────────\n"
}

# 计算已答题数
count_answered() {
    echo ${#USER_ANSWERS[@]}
}

# 计算各维度当前得分
calculate_dimension_scores() {
    # 重置所有维度得分
    for dim in "${!DIMENSION_SCORES[@]}"; do
        DIMENSION_SCORES[$dim]=0
    done
    
    # 遍历所有已回答的题目
    for idx in "${!USER_ANSWERS[@]}"; do
        answer_value=${USER_ANSWERS[$idx]}
        question_line=${QUESTIONS[$idx]}
        dimension=$(echo "$question_line" | cut -d'|' -f1)
        
        # 转换答案值：1-3为负向，5为正向，4为中立
        # 1: -2, 2: -1, 3: 0, 4: +1, 5: +2
        case "$answer_value" in
            1) score=-2 ;;
            2) score=-1 ;;
            3) score=0 ;;
            4) score=1 ;;
            5) score=2 ;;
            *) score=0 ;;
        esac
        
        DIMENSION_SCORES[$dimension]=$((DIMENSION_SCORES[$dimension] + score))
    done
}

# 获取维度倾向描述
get_dimension_tendency() {
    local score=$1
    if (( score < -8 )); then
        echo "极端左翼 ▼▼"
    elif (( score < -4 )); then
        echo "左翼倾向 ▼"
    elif (( score <= 4 )); then
        echo "中立立场 ◄►"
    elif (( score <= 8 )); then
        echo "右翼倾向 ▲"
    else
        echo "极端右翼 ▲▲"
    fi
}

# 分析响应模式
analyze_response_pattern() {
    local neutral_count=0
    local extreme_count=0
    local total_answered=$(count_answered)
    
    if (( total_answered == 0 )); then
        echo "未开始"
        return
    fi
    
    # 计算中立和极端回答数
    for answer in "${USER_ANSWERS[@]}"; do
        if [[ $answer -eq 3 ]]; then
            ((neutral_count++))
        elif [[ $answer -eq 1 ]] || [[ $answer -eq 5 ]]; then
            ((extreme_count++))
        fi
    done
    
    local neutral_ratio=$((neutral_count * 100 / total_answered))
    local extreme_ratio=$((extreme_count * 100 / total_answered))
    
    if (( extreme_ratio > 60 )); then
        echo "极端化立场"
    elif (( neutral_ratio > 60 )); then
        echo "极端谨慎/高度中立"
    elif (( neutral_ratio > 40 )); then
        echo "谨慎/中立倾向"
    elif (( extreme_ratio > 40 )); then
        echo "明确而坚定的立场"
    else
        echo "适度和均衡"
    fi
}

# 计算置信度（根据答题比例）
calculate_confidence() {
    local answered=$(count_answered)
    local confidence=$((answered * 100 / TOTAL_QUESTIONS))
    echo "$confidence%"
}

# 生成统计数据区（20行）
generate_statistics_area() {
    local answered=$(count_answered)
    local confidence=$(calculate_confidence)
    local response_pattern=$(analyze_response_pattern)
    
    calculate_dimension_scores
    
    # 第1行：已答信息
    printf "已答题目数：%d / %d\n" "$answered" "$TOTAL_QUESTIONS"
    
    # 第2-17行：各维度得分（16个维度）
    printf "├─ 经济维度：%+5d  $(get_dimension_tendency ${DIMENSION_SCORES[economic]})\n" \
        "${DIMENSION_SCORES[economic]}"
    printf "├─ 政治维度：%+5d  $(get_dimension_tendency ${DIMENSION_SCORES[political]})\n" \
        "${DIMENSION_SCORES[political]}"
    printf "├─ 社会维度：%+5d  $(get_dimension_tendency ${DIMENSION_SCORES[social]})\n" \
        "${DIMENSION_SCORES[social]}"
    printf "├─ 权力集中度：%+5d\n" "${DIMENSION_SCORES[authoritarianism]}"
    printf "├─ 军国主义倾向：%+5d\n" "${DIMENSION_SCORES[militarism]}"
    printf "├─ 民族主义倾向：%+5d\n" "${DIMENSION_SCORES[nationalism]}"
    printf "├─ 宗教/世俗性：%+5d\n" "${DIMENSION_SCORES[religion]}"
    printf "├─ 进步倾向：%+5d\n" "${DIMENSION_SCORES[progress]}"
    printf "├─ 传统倾向：%+5d\n" "${DIMENSION_SCORES[tradition]}"
    printf "├─ 环保主义：%+5d\n" "${DIMENSION_SCORES[environmentalism]}"
    printf "├─ 个人主义：%+5d\n" "${DIMENSION_SCORES[individualism]}"
    printf "├─ 集体主义：%+5d\n" "${DIMENSION_SCORES[collectivism]}"
    printf "├─ 科学理性：%+5d\n" "${DIMENSION_SCORES[scientific]}"
    printf "├─ 务实主义：%+5d\n" "${DIMENSION_SCORES[pragmatism]}"
    printf "├─ 理想主义：%+5d\n" "${DIMENSION_SCORES[idealism]}"
    printf "└─ 本地化倾向：%+5d\n" "${DIMENSION_SCORES[localism]}"
    
    # 第18行：响应模式
    printf "\n响应模式：%s\n" "$response_pattern"
    
    # 第19行：置信度
    printf "测试完成度：%s\n" "$confidence"
}

# 渲染完整UI界面
render_ui() {
    clear_screen
    
    # 第1行：标题和题号
    printf "量表名称：9Axes - 政治倾向多维分析测试        题目：%d / %d\n" \
        "$((CURRENT_QUESTION + 1))" "$TOTAL_QUESTIONS"
    
    # 第2行：当前时间
    printf "当前时间：%s\n" "$(get_current_time)"
    
    # 第3行：分隔线
    print_separator
    
    # 第4-23行：动态统计区（20行）
    generate_statistics_area
    
    # 第24行：分隔线
    print_separator
    
    # 第25行：当前题目
    local question_text=$(echo "${QUESTIONS[$CURRENT_QUESTION]}" | cut -d'|' -f2)
    printf "题目：%s\n" "$question_text"
    
    # 第26行：分隔线
    print_separator
    
    # 第27-31行：选项
    printf "1. 非常反对\n"
    printf "2. 反对\n"
    printf "3. 中立\n"
    printf "4. 同意\n"
    printf "5. 非常同意\n"
    
    # 第32行：分隔线
    print_separator
}

# 显示用户输入提示
show_input_prompt() {
    printf "请选择 (1-5, 0-跳过, q-退出)："
}

# 获取用户输入
get_user_input() {
    local input
    read -n 1 input
    echo ""
    echo "$input"
}

# 处理用户输入
process_input() {
    local input=$1
    
    case "$input" in
        1|2|3|4|5)
            # 记录答案
            USER_ANSWERS[$CURRENT_QUESTION]=$input
            
            # 移到下一题
            ((CURRENT_QUESTION++))
            
            # 检查是否完成所有题目
            if (( CURRENT_QUESTION >= TOTAL_QUESTIONS )); then
                show_completion_screen
                exit 0
            fi
            return 0
            ;;
        0|"")
            # 跳过此题
            ((CURRENT_QUESTION++))
            
            if (( CURRENT_QUESTION >= TOTAL_QUESTIONS )); then
                show_completion_screen
                exit 0
            fi
            return 0
            ;;
        q|Q)
            # 退出
            printf "\n感谢使用本问卷。再见！\n"
            exit 0
            ;;
        *)
            # 无效输入，重新提示
            printf "\n无效选择，请重试。\n"
            sleep 1
            return 1
            ;;
    esac
}

# 显示完成屏幕
show_completion_screen() {
    clear_screen
    printf "╔════════════════════════════════════════╗\n"
    printf "║       🎉 测试已完成！🎉              ║\n"
    printf "╚════════════════════════════════════════╝\n\n"
    
    calculate_dimension_scores
    
    printf "您的政治倾向分析结果：\n\n"
    
    # 主要维度分析
    printf "┌─ 主要维度分析 ─────────────────────────┐\n"
    printf "│ 经济立场：%-30s │\n" "$(get_dimension_tendency ${DIMENSION_SCORES[economic]})"
    printf "│ 政治立场：%-30s │\n" "$(get_dimension_tendency ${DIMENSION_SCORES[political]})"
    printf "│ 社会立场：%-30s │\n" "$(get_dimension_tendency ${DIMENSION_SCORES[social]})"
    printf "└────────────────────────────────────────┘\n\n"
    
    # 详细数据
    printf "16维度详细分数：\n"
    printf "  经济：%+5d  政治：%+5d  社会：%+5d  权力：%+5d\n" \
        "${DIMENSION_SCORES[economic]}" \
        "${DIMENSION_SCORES[political]}" \
        "${DIMENSION_SCORES[social]}" \
        "${DIMENSION_SCORES[authoritarianism]}"
    printf "  军国：%+5d  民族：%+5d  宗教：%+5d  进步：%+5d\n" \
        "${DIMENSION_SCORES[militarism]}" \
        "${DIMENSION_SCORES[nationalism]}" \
        "${DIMENSION_SCORES[religion]}" \
        "${DIMENSION_SCORES[progress]}"
    printf "  传统：%+5d  环保：%+5d  个人：%+5d  集体：%+5d\n" \
        "${DIMENSION_SCORES[tradition]}" \
        "${DIMENSION_SCORES[environmentalism]}" \
        "${DIMENSION_SCORES[individualism]}" \
        "${DIMENSION_SCORES[collectivism]}"
    printf "  科学：%+5d  务实：%+5d  理想：%+5d  本地：%+5d\n" \
        "${DIMENSION_SCORES[scientific]}" \
        "${DIMENSION_SCORES[pragmatism]}" \
        "${DIMENSION_SCORES[idealism]}" \
        "${DIMENSION_SCORES[localism]}"
    printf "\n"
    
    printf "总体分析：\n"
    printf "  完成度：$(calculate_confidence)\n"
    printf "  答题模式：$(analyze_response_pattern)\n"
    printf "  已回答：$(count_answered) 题\n\n"
    
    printf "感谢您完成此问卷调查！\n"
}

# ============================================================================
# 主程序入口
# ============================================================================

main() {
    # 初始化题库总数
    TOTAL_QUESTIONS=${#QUESTIONS[@]}
    CURRENT_QUESTION=0
    
    # 欢迎屏幕
    clear_screen
    printf "╔════════════════════════════════════════╗\n"
    printf "║   欢迎使用 9Axes 政治倾向测试系统    ║\n"
    printf "╚════════════════════════════════════════╝\n\n"
    printf "本测试包含 %d 道题目，分布在16个维度上。\n" "$TOTAL_QUESTIONS"
    printf "旨在全面深入地分析您的政治倾向。\n"
    printf "所有数据仅用于研究目的，完全保密。\n\n"
    printf "按任意键开始...\n"
    read -n 1
    
    # 主循环
    while (( CURRENT_QUESTION < TOTAL_QUESTIONS )); do
        render_ui
        show_input_prompt
        
        input=$(get_user_input)
        process_input "$input"
        
        # 如果处理返回非零（比如无效输入），重新提示
        if (( $? != 0 )); then
            sleep 1
        fi
    done
}

# 启动程序
main
