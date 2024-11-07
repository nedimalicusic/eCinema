using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieValidator : AbstractValidator<MovieUpsertDto>
    {
        public MovieValidator()
        {
            RuleFor(c => c.Title).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Description).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Author).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.ReleaseYear).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Duration).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.LanguageId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ProductionId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
