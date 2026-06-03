package com.s_giken.training.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.s_giken.training.webapp.exception.AttributeErrorException;
import com.s_giken.training.webapp.exception.NotFoundException;
import com.s_giken.training.webapp.model.entity.Charge;
import com.s_giken.training.webapp.model.entity.ChargeSearchCondition;
import com.s_giken.training.webapp.service.IChargeService;

@Controller
@RequestMapping("/charge")
public class ChargeController {

    private final IChargeService chargeService;

    public ChargeController(IChargeService chargeService) {
        this.chargeService = chargeService;
    }

    @GetMapping("/search")
    public String showSearchCondition(Model model) {

        var chargeSearchCondition = new ChargeSearchCondition();
        model.addAttribute("chargeSearchCondition", chargeSearchCondition);

        return "charge_search_condition";
    }

    @PostMapping("/search")
    public String searchAndListing(@ModelAttribute ChargeSearchCondition chargeSearchCondition, Model model) {

        var result = chargeService.findByConditions(chargeSearchCondition);
        model.addAttribute("result", result);

        return "charge_search_result";
    }

    @GetMapping("/edit/{id}")
    public String editCharge(@PathVariable Long id, Model model) {

        var charge = chargeService.findById(id); // 戻り値：Optional<Charge>
        if (!charge.isPresent()) {
            throw new NotFoundException(String.format("指定したid(%d)の料金情報が存在しません。", id));
        }
        model.addAttribute("isAddMode", false);
        model.addAttribute("charge", charge.get());

        return "charge_edit";
    }

    @GetMapping("/add")
    public String formAddCharge(Model model) {

        Charge charge = new Charge();
        model.addAttribute("isAddMode", true);
        model.addAttribute("charge", charge);

        return "charge_edit";
    }

    @PostMapping("/add")
    @Transactional
    public String addCharge(@Validated Charge charge, BindingResult result, RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "charge_edit";
        }

        try {
            chargeService.add(charge);
        } catch (AttributeErrorException e) {
            result.rejectValue("startDate", e.getMessage());
            return "charge_edit";
        }
        redirectAttributes.addFlashAttribute("message", "保存しました。");

        return "redirect:/charge/edit/" + charge.getId();
    }

    @PostMapping("/update")
    @Transactional
    public String saveCharge(@Validated Charge charge, BindingResult result, RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "charge_edit";
        }

        try {
            chargeService.update(charge);
        } catch (AttributeErrorException e) {
            result.rejectValue("startDate", e.getMessage());
            return "charge_edit";
        }
        redirectAttributes.addFlashAttribute("message", "保存しました。");

        return "redirect:/charge/edit/" + charge.getId();
    }

    @GetMapping("/delete/{id}")
    @Transactional
    public String deleteCharge(@PathVariable Long id, RedirectAttributes redirectAttributes) {

        var charge = chargeService.findById(id);
        if (!charge.isPresent()) {
            throw new NotFoundException(String.format("指定したid(%d)の加入者情報が存在しません。", id));
        }
        chargeService.deleteById(id);
        redirectAttributes.addFlashAttribute("message", "削除しました。");

        return "redirect:/charge/search";
    }

}
