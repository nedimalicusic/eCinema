using eCinema.Core;
using FluentValidation;

namespace eCinema.Application.Validators
{
    public class CategoryValidator : AbstractValidator<CategoryUpsertDto>
    {
        public CategoryValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.IsDisplayed).NotEmpty().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
