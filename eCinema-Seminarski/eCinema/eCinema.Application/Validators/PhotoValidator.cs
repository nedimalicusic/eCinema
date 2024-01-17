using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class PhotoValidator : AbstractValidator<PhotoUpsertDto>
    {
        public PhotoValidator()
        {
            RuleFor(c => c.Data).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
